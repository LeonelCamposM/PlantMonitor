#include <WebServer.h>
#include <ArduinoJson.h>

WebServer server(80);

void onGetSensorData() {
  StaticJsonDocument<200> jsonDoc;
  int percentageBattery = getBatteryPercentage();
  jsonDoc["humidity"] = getMoisturePercentage();
  jsonDoc["battery"] = percentageBattery;
  String jsonString;
  serializeJson(jsonDoc, jsonString);
  server.send(200, "json/doc", jsonString);
}

void startHttpServer(){
  server.on("/getSensorData", HTTP_GET, onGetSensorData);
  #ifdef DEBUG
  Serial.println("Listening on 192.168.1.22:80");
  #endif
  server.begin();
}

void serverHandleClient(){
  server.handleClient();
}