#ifdef AP_MODE
#include <WebServer.h>
#include <ArduinoJson.h>
#include "index.h"

WebServer server(80);

void onConfig() {
  StaticJsonDocument<200> jsonDoc;
  for (int i = 0; i < server.args(); i++) {
    jsonDoc[server.argName(i)] = server.arg(i);
  }
  if (jsonDoc["communicationType"] == "wifi") {
    Serial.println("wifi mode selected");
    server.send(200, "text/html", "ok wifi");
  }else{
    Serial.println("ap mode selected");
    server.send(200, "text/html", "ok ap");
  }
}

void onGetSensorData() {
  StaticJsonDocument<200> jsonDoc;
  int percentageBattery = getBatteryPercentage();
  jsonDoc["humidity"] = getMoisturePercentage();
  jsonDoc["date"] = "today";
  jsonDoc["battery"] = percentageBattery;
  String jsonString;
  serializeJson(jsonDoc, jsonString);
  server.send(200, "json/doc", jsonString);
}

void onHome() {
  String s = MAIN_page;  
  server.send(200, "text/html", s);
}

void startHttpServer(){
  server.on("/config", HTTP_POST, onConfig);
  server.on("/getSensorData", HTTP_GET, onGetSensorData);
  server.on("/", HTTP_GET, onHome);
  server.begin();
  Serial.println("Listening on 192.168.1.22:80");
}

void serverHandleClient(){
  server.handleClient();
}
#endif