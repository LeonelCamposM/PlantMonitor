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

void onGetAllData(){
  String response = getAllData();
  server.send(200, "json/doc", response);
}

void startHttpServer(){
  server.on("/getSensorData", HTTP_GET, onGetSensorData);
  server.begin();
  #ifdef DEBUG
  Serial.println("Listening on 192.168.1.22:80");
  #endif
}

void serverHandleClient(){
  server.handleClient();
}