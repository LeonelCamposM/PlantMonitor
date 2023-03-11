#include <WebServer.h>
#include <ArduinoJson.h>

#include <WiFi.h>
#include "ESPAsyncWebServer.h"

#define MEASURE_PATH "/measure_data.txt"
#define PREFERENCES_PATH "/preferences.txt"
const char* PARAM_MESSAGE = "limits";

AsyncWebServer server(80);

void startHttpServer() {

  server.on("/onUpdatePreferences", HTTP_GET, [](AsyncWebServerRequest* request) {
    String message;
    if (request->hasParam(PARAM_MESSAGE)) {
      message = request->getParam(PARAM_MESSAGE)->value();
      saveData(PREFERENCES_PATH, message, "");
    } else {
      message = "No message sent";
    }
    request->send(200, "text/plain", "Receive: " + message);
  });

  server.on("/onDeleteAllData", HTTP_GET, [](AsyncWebServerRequest* request) {
    bool response = remove_file(MEASURE_PATH);
    if(response){
      request->send(200, "text/plain", "200");
    } else {
      request->send(200, "text/plain", "404");
    }
  });

  server.on("/getAllData", HTTP_GET, [](AsyncWebServerRequest* request) {
    request->send(200, "text/plain", getAllData(MEASURE_PATH));
  });

  server.on("/getName", HTTP_GET, [](AsyncWebServerRequest* request) {
    request->send(200, "text/plain", "loraMonitor");
  });

  server.begin();

#ifdef DEBUG
  Serial.println("Listening on 192.168.1.22:80");
#endif
}
