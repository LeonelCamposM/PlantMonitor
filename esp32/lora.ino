#include <SPI.h>
#include <LoRa.h>
#include <Wire.h>

#define SCLK 5   // GPIO5  -- SX1278's SCLK
#define MISO 19  // GPIO19 -- SX1278's MISO
#define MOSI 27  // GPIO27 -- SX1278's MOSI
#define CS 18    // GPIO18 -- SX1278's CS
#define RST 14   // GPIO14 -- SX1278's RESET
#define DI0 26   // GPIO26 -- SX1278's IRQ(Interrupt Request)
#define BAND 903E6

#define MEASURE_PATH "/measure_data.txt"

String rssi = "RSSI --";
String messageSize = "--";
String packet;

bool startLora() {
  bool error = false;
  SPI.begin(SCLK, MISO, MOSI, CS);
  LoRa.setPins(CS, RST, DI0);
  if (!LoRa.begin(BAND)) {
    Serial.println("Starting LoRa failed!");
    error = true;
  }
  LoRa.receive();
  return error;
}

void handleRequest(int packetSize, String date) {
  Serial.println("LoRa Receiver Callback");
  packet = "";
  messageSize = String(packetSize, DEC);
  for (int i = 0; i < packetSize; i++) { packet += (char)LoRa.read(); }
  rssi = "RSSI " + String(LoRa.packetRssi(), DEC);
  Serial.println("[Server] sending ack");
  sendLora("ack");
  saveData(MEASURE_PATH, packet, date);
  Serial.println("Received " + messageSize + " bytes");
  Serial.println(packet);
  Serial.println(rssi);
}

String receiveLora(String date) {
  while (true) {
    packet = "";
    int packetSize = LoRa.parsePacket();
    if (packetSize) {
      handleRequest(packetSize, date);
      break;
    }
    delay(100);
  }
  return packet;
}

String timeoutReceiveLora() {
  int timeWaited = 0;
  while (true) {
    packet = "";
    if (timeWaited > 5000) {
      Serial.println("[Sensor] timeout");
      break;
    }
    int packetSize = LoRa.parsePacket();
    Serial.println(packetSize);
    if (packetSize) { 
      Serial.println("[Sensor] ack arrived");
      packet = "ack";
      break;
    }
    delay(100);
    timeWaited += 100;
  }
  return packet;
}

void ackSendLora(String message) {
  String ack = "";
  int timeWaited = 0;
  while (ack != "ack") {
    if(timeWaited > 15000){
      ack = "error";
      break;
    }

    sendLora(message);
    ack = timeoutReceiveLora();
    Serial.println(ack);
    timeWaited += 5000;
    if (ack == "") {
      Serial.println("[Sensor] Stop listening ack by timeout ... ");
    }
  }

  if (ack == "error") {
    Serial.println("[Sensor] server unreachable ");
  } else {
    Serial.println("[Sensor] arrived ack: " + ack);
    setChargeLed(true);
    delay(1000);
    setChargeLed(false);
  }
}

void sendLora(String message) {
  int counter = 0;
  while (counter != 10) {
    LoRa.beginPacket();
    LoRa.print(message);
    LoRa.endPacket();
    delay(100);
    counter++;
  }
}

void sleepLora() {
  LoRa.sleep();
}
