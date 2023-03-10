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

  server.on("/onGetAllData", HTTP_GET, [](AsyncWebServerRequest* request) {
    request->send(200, "text/plain", getAllData(MEASURE_PATH));
  });

  server.on("/getLimits", HTTP_GET, [](AsyncWebServerRequest* request) {
    request->send(200, "text/plain", getAllData(PREFERENCES_PATH));
  });

  server.begin();

#ifdef DEBUG
  Serial.println("Listening on 192.168.1.22:80");
#endif
}
