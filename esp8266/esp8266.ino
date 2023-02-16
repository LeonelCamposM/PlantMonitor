#include <ESP8266WiFi.h>

const int moisturePin = A0;
int maxMoisture = 1023; // dry 
int minMoisture = 1172; // wet

int getMoisturePercentage() {
  int sensorValue = analogRead(moisturePin);
  int percentageHumidity = map(sensorValue, minMoisture, maxMoisture, 100, 0);
  if(percentageHumidity < 0 || sensorValue == 0) {
    percentageHumidity = 0;
  }
  if(percentageHumidity > 100) {
    percentageHumidity = 100;
  }
  Serial.print("Moisture: "); 
  Serial.print(sensorValue); 
  Serial.print(" percentage: ");
  Serial.print(percentageHumidity);
  Serial.println("");
  return percentageHumidity;
}

void setup() { 
  Serial.begin(115200);
  while (!Serial);
  Serial.println("awake5");
  delay(10000);
  Serial.println("Modo ESP8266 deep sleep durante 10 segundos");
  //ESP.deepSleep(20e6); 
}

void loop() {
  // getMoisturePercentage(); 
  // delay(4000);
}