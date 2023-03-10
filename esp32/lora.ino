#include <SPI.h>
#include <LoRa.h>
#include <Wire.h>   

#define SCLK     5    // GPIO5  -- SX1278's SCLK
#define MISO    19   // GPIO19 -- SX1278's MISO
#define MOSI    27   // GPIO27 -- SX1278's MOSI
#define CS      18   // GPIO18 -- SX1278's CS
#define RST     14   // GPIO14 -- SX1278's RESET
#define DI0     26   // GPIO26 -- SX1278's IRQ(Interrupt Request)
#define BAND    903E6

String rssi = "RSSI --";
String messageSize = "--";
String packet;

bool startLora() {
  bool error = false;
  SPI.begin(SCLK,MISO,MOSI,CS);
  LoRa.setPins(CS,RST,DI0);  
  if (!LoRa.begin(BAND)) {
    Serial.println("Starting LoRa failed!");
    error = true;
  }
  LoRa.receive(); 
  return error;
}

void handleRequest(int packetSize) {
  Serial.println("LoRa Receiver Callback");
  packet ="";
  messageSize = String(packetSize,DEC);
  for (int i = 0; i < packetSize; i++) { packet += (char) LoRa.read(); }
  rssi = "RSSI " + String(LoRa.packetRssi(), DEC) ;

  Serial.println("Received "+ messageSize + " bytes");
  Serial.println(packet);
  Serial.println(rssi);
}

String receiveLora(){
  while(true ) {
    packet = "";
    int packetSize = LoRa.parsePacket();
    if (packetSize) { 
      handleRequest(packetSize);  
      break;
    }
    delay(100);
  }
  return packet;
}

String timeoutReceiveLora(){
  int timeWaited = 0;
  while(true ) {
    packet = "";
    if(timeWaited > 5000){
      Serial.println("[Sensor] timeout");
      break;  
    }
    int packetSize = LoRa.parsePacket();
    if (packetSize) { 
      handleRequest(packetSize);  
      break;
    }
    delay(100);
    timeWaited += 100;
  }
  return packet;
}

void ackSendLora(String message){
  String ack = "";
  int timeWaited = 0;
  while (ack != message) {
    if(timeWaited > 10000){
      ack = "error";
      break;
    }

    sendLora(message);
    ack = timeoutReceiveLora();
    timeWaited += 5000;
    if(ack == ""){
      Serial.println("[Sensor] Stop listening ack by timeout ... "); 
    }
  }
  
  if(ack == "error"){
    Serial.println("[Sensor] server unreachable ");
  }else{
    Serial.println("[Sensor] arrived ack: " + ack);
  }
}

void sendLora(String message){
  LoRa.beginPacket();
  LoRa.print(message);
  LoRa.endPacket();
}

void sleepLora(){
  LoRa.sleep();
}

