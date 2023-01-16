#include <WiFi.h>                                  
#include <WebServer.h>
#include <ArduinoJson.h>
#include <Wire.h>
#include <axp20x.h>

const char* ssid = "PLANTMONITOR";
const char* password = "12345leo";

IPAddress local_IP(192,168,1,22);
IPAddress gateway(192,168,1,5);
IPAddress subnet(255,255,255,0);
WebServer server(80);

const int moisturePin = 2;
int maxMoisture = 2930; // dry 
int minMoisture = 1697; // wet
AXP20X_Class axp;

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
  int sensorValue = analogRead(moisturePin);
  int percentageHumidity = map(sensorValue, minMoisture, maxMoisture, 100, 0);
  if(percentageHumidity < 0){
    percentageHumidity = 0;
  }
   if(percentageHumidity > 100){
    percentageHumidity = 100;
  }
  Serial.println("Moisture: "); 
  Serial.println(sensorValue); 
  Serial.println(percentageHumidity); 
  jsonDoc["humidity"] = percentageHumidity;
  jsonDoc["date"] = "today";
  String jsonString;
  serializeJson(jsonDoc, jsonString);
  server.send(200, "json/doc", jsonString);
}

void startAccesPoint(){
  Serial.print("Setting up Access Point ... ");
  Serial.println(WiFi.softAPConfig(local_IP, gateway, subnet) ? "Ready" : "Failed!");

  Serial.print("Starting Access Point ... ");
  Serial.println(WiFi.softAP(ssid, password) ? "Ready" : "Failed!");

  Serial.print("IP address = ");
  Serial.println(WiFi.softAPIP());
}

void startHttpServer(){
  server.on("/config", HTTP_POST, onConfig);
  server.on("/getSensorData", HTTP_GET, onGetSensorData);
  server.begin();
  Serial.println("Listening on 192.168.1.22:80");
}
 
void setup() {
  Serial.begin(115200);
  Wire.begin(21, 22);
  if(axp.begin(Wire, AXP192_SLAVE_ADDRESS) == AXP_FAIL) {
    Serial.println(F("failed to initialize communication with AXP192"));
  }  
  // startAccesPoint();
  // startHttpServer();
    // Start charging the battery if it is installed.
  // pmu.setChargeControlCur(AXP1XX_CHARGE_CUR_1000MA);
  // pmu.setChargingTargetVoltage(AXP202_TARGET_VOL_4_2V);
  // pmu.enableChargeing(true);
  // pmu.setChgLEDMode(AXP20X_LED_OFF);
}

void loop() {
  // server.handleClient();
  // int sensorValue = analogRead(moisturePin);
  // int percentageHumidity = map(sensorValue, minMoisture, maxMoisture, 100, 0);
  // Serial.println("Moisture: "); 
  // Serial.println(sensorValue); 
  // Serial.println(percentageHumidity); 
  // delay(3000);
  Serial.println("Battery:");
  Serial.println(axp.getBattChargeCurrent());
  Serial.print(axp.getBattVoltage());
  Serial.println(" mV");
  delay(2000);
}

// Power Managment charge battery AXP192
// #include <Wire.h>
// // https://github.com/lewisxhe/AXP202X_Library
// #include <axp20x.h>

// AXP20X_Class axp;

// void setup() {
//   Serial.begin(115200); 
//   Wire.begin(21, 22);
//   if(axp.begin(Wire, AXP192_SLAVE_ADDRESS) == AXP_FAIL) {
//     Serial.println(F("failed to initialize communication with AXP192"));
//   }  
//   // // Start charging the battery if it is installed.
//   // axp.setChargeControlCur(AXP1XX_CHARGE_CUR_450MA);
//   // axp.setChargingTargetVoltage(AXP202_TARGET_VOL_4_2V);
//   // axp.enableChargeing(true);
//   // Serial.println("Charging:");
//   // axp.setChgLEDMode(AXP20X_LED_LOW_LEVEL);
//   // startAccesPoint();
// }

// void loop() {
//   // Serial.println("Battery:");
//   // Serial.println(axp.getBattChargeCurrent());
//   // Serial.print(axp.getBattVoltage());
//   // Serial.println(" mV");
//   // delay(2000);
// }