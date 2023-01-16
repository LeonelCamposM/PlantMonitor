#include <WiFi.h>                                  
#include <WebServer.h>
#include <ArduinoJson.h>
#include <Wire.h>
#include <axp20x.h>
#include <EEPROM.h>

#define EEPROM_SIZE 1

const char* ssid = "PLANTMONITOR";
const char* password = "12345leo";

IPAddress local_IP(192,168,1,22);
IPAddress gateway(192,168,1,5);
IPAddress subnet(255,255,255,0);
WebServer server(80);

const int moisturePin = 2;
int maxMoisture = 2930; // dry 
int minMoisture = 1697; // wet
int percentageHumidity;
AXP20X_Class axp;

bool boardMode = true; // read

const int modeAddr = 0;
int modeIdx;

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
  if(percentageHumidity < 0){
    percentageHumidity = 0;
  }
   if(percentageHumidity > 100){
    percentageHumidity = 100;
  }
  int percentageBatery = map(axp.getBattVoltage(), 4000, 0, 100, 0);
  Serial.print(axp.getBattVoltage()); 
  Serial.print("Batery: "); 
  Serial.println(percentageBatery);
  Serial.println(""); 
  Serial.print("Moisture: "); 
  Serial.println(percentageHumidity); 
  jsonDoc["humidity"] = percentageHumidity;
  jsonDoc["date"] = "today";
  jsonDoc["batery"] = percentageBatery;
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
  // axp.setChargeControlCur(AXP1XX_CHARGE_CUR_550MA);
  // axp.setChargingTargetVoltage(AXP202_TARGET_VOL_4_2V);
  // axp.enableChargeing(true);
  
  if(!EEPROM.begin(EEPROM_SIZE)){
    delay(1000);
  }

  modeIdx = EEPROM.read(modeAddr);
  Serial.print("modeIdx : ");
  Serial.println(modeIdx);

  EEPROM.write(modeAddr, modeIdx !=0 ? 0 : 1);
  EEPROM.commit();

  if(modeIdx != 0){
    //READ
    axp.setChgLEDMode(AXP20X_LED_OFF);
    Serial.println("READ MODE");
  }else{
    //VIEW
    axp.setChgLEDMode(AXP20X_LED_LOW_LEVEL);
    Serial.println("AP MODE");
    WiFi.softAPdisconnect (true);
    int sensorValue = analogRead(moisturePin);
    percentageHumidity = map(sensorValue, minMoisture, maxMoisture, 100, 0);
    Serial.println("Moisture: "); 
    Serial.println(sensorValue); 
    Serial.println(percentageHumidity); 
    Serial.println("");
    startAccesPoint();
    startHttpServer();
  }
}

void loop() {
  if(modeIdx != 0){
    WiFi.softAPdisconnect (true);
    int sensorValue = analogRead(moisturePin);
    percentageHumidity = map(sensorValue, minMoisture, maxMoisture, 100, 0);
    // Serial.println("Moisture: "); 
    // Serial.println(sensorValue); 
    // Serial.println(percentageHumidity); 
    // Serial.println("");
    // Serial.println("Battery:");
    // Serial.print(axp.getBattVoltage());
    // Serial.println(" mV");
    delay(2000);
  }else{
    //VIEW
    server.handleClient();  
    delay(1);
  }
}
