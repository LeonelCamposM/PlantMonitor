const int moisturePin = 36;
int maxMoisture = 2913; // dry 
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
  #ifdef DEBUG
  Serial.print("Moisture: "); 
  Serial.print(sensorValue); 
  Serial.print(" percentage: ");
  Serial.print(percentageHumidity);
  Serial.println("");
  #endif
  return percentageHumidity;
}