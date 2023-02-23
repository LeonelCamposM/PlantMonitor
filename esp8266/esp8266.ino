#include "SPI.h"
#include "SD.h"
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

const char*  WIFI_SSID = "ARRIS-3215";
const char*  WIFI_PASSWORD = "50A5DC803215";
const String apiKey = "8965126";
String phoneNumber = "50683355317";
String url;

const int moisturePin = A0;
const int chipSelect = D8;
int maxMoisture = 712  ; // dry 
int minMoisture = 300; // wet
File myFile;


int getMoisturePercentage() {
  int sensorValue = analogRead(moisturePin);
  int percentageHumidity = map(sensorValue, minMoisture, maxMoisture, 100, 0);
  if(percentageHumidity < 0 || sensorValue == 0) {
    percentageHumidity = 0;
  }
  if(percentageHumidity > 100) {
    percentageHumidity = 100;
  }
  return percentageHumidity;
}

void sendMessage(String message){
  String url = "http://api.callmebot.com/whatsapp.php?phone=" + phoneNumber + "&apikey=" + apiKey + "&text=" + message;
  WiFiClient client;    
  HTTPClient http;
  http.begin(client, url);
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");
  
  int httpResponseCode = http.POST(url);
  if (httpResponseCode == 200){
  }
  else{
  }

  http.end();
}

void setup() { 
  Serial.begin(115200);
  while (!Serial);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  int i = 0;
  while (WiFi.status() != WL_CONNECTED) { 
    delay(1000);
  }

  sendMessage("Humedad:+"+String(getMoisturePercentage())); 

  if (!SD.begin(chipSelect)) {
    Serial.println("Initialization failed!");
  }else{
    Serial.println("Initialization ok");
    
    myFile = SD.open("test.txt", FILE_WRITE);
    if (myFile) {
      myFile.println("Humedad:+"+String(getMoisturePercentage()));
      myFile.close();
    } else {
    }

    myFile = SD.open("test.txt");
    if (myFile) {
      Serial.println("LOG :");
      while (myFile.available()) {
        Serial.write(myFile.read());
      }
      myFile.close();
    } else {
      Serial.println("error opening test.txt");
    }
  }
  delay(20000);
  ESP.deepSleep(3600e6); 
}

void loop() {
}