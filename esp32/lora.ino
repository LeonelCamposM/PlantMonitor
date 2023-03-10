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
String globalPacket;

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
  packet = "";
  messageSize = String(packetSize, DEC);
  for (int i = 0; i < packetSize; i++) { packet += (char)LoRa.read(); }
  rssi = "RSSI " + String(LoRa.packetRssi(), DEC);
  saveData(MEASURE_PATH, packet, date);
  #ifdef DEBUG
    Serial.println("Received " + messageSize + " bytes");
    Serial.println(packet);
    Serial.println(rssi);
  #endif
}

String receiveLora(String date) {
  while (true) {
    packet = "";
    int packetSize = LoRa.parsePacket();
    if (packetSize) {
      handleRequest(packetSize, date);
      break;
    }
  }
  return packet;
}

void sendLora(String message) {
  LoRa.beginPacket();
  LoRa.print(message);
  LoRa.endPacket();
}

void sleepLora() {
  LoRa.sleep();
}
