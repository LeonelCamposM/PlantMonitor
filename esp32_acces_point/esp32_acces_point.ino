#include <WiFi.h>                                  
#include <WebServer.h>

const char* ssid = "PLANTMONITOR";
const char* password = "12345leo";

IPAddress local_IP(192,168,1,22);
IPAddress gateway(192,168,1,5);
IPAddress subnet(255,255,255,0);
WebServer server(80);



void onConfig() {
  Serial.println("new config request");
  server.send(200, "text/html", "configSucces"); // 3
}

String SendHTML() {
  String ptr = "<!DOCTYPE html> Hello <html>\n";
  return ptr;
}

void setup() {
  Serial.begin(115200);                              
 
  Serial.print("Setting up Access Point ... ");
  Serial.println(WiFi.softAPConfig(local_IP, gateway, subnet) ? "Ready" : "Failed!");

  Serial.print("Starting Access Point ... ");
  Serial.println(WiFi.softAP(ssid, password) ? "Ready" : "Failed!");

  Serial.print("IP address = ");
  Serial.println(WiFi.softAPIP());

  server.on("/config/", onConfig);
  server.begin();
  Serial.println("Servidor HTTP iniciado");
}

void loop() {
  server.handleClient();
}