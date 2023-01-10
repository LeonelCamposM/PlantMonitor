#include <WiFi.h>                                  
#include <WebServer.h>
#include <ArduinoJson.h>

const char* ssid = "PLANTMONITOR";
const char* password = "12345leo";

IPAddress local_IP(192,168,1,22);
IPAddress gateway(192,168,1,5);
IPAddress subnet(255,255,255,0);
WebServer server(80);

void onConfig() {
  StaticJsonDocument<200> jsonDoc;
  for (int i = 0; i < server.args(); i++) {
    jsonDoc[server.argName(i)] = server.arg(i);
  }
  if (jsonDoc["communicationType"] == "wifi") {
    Serial.println("wifi mode selected");
    // Serial.println(jsonDoc["wifiName"]);
    // Serial.println(jsonDoc["wifiPass"]);
    // Serial.println(jsonDoc["wifi conf done"]);
    server.send(200, "text/html", "ok wifi");
  }else{
    Serial.println("ap mode selected");
    server.send(200, "text/html", "ok ap");
  }
}
 
void setup() {
  Serial.begin(115200);                              
 
  Serial.print("Setting up Access Point ... ");
  Serial.println(WiFi.softAPConfig(local_IP, gateway, subnet) ? "Ready" : "Failed!");

  Serial.print("Starting Access Point ... ");
  Serial.println(WiFi.softAP(ssid, password) ? "Ready" : "Failed!");

  Serial.print("IP address = ");
  Serial.println(WiFi.softAPIP());

  // handle post request
  server.on("/config", HTTP_POST, onConfig);
  server.begin();
  Serial.println("Servidor HTTP iniciado");
}

void loop() {
  server.handleClient();
}