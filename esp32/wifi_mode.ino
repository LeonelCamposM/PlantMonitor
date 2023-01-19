#ifdef WIFI_MODE
#include "FirebaseESP32.h"

const char*  WIFI_SSID = "ARRIS-3215";
const char*  WIFI_PASSWORD = "50A5DC803215";
const char* FIREBASE_HOST  = "https://plantmonitor-ec8fe-default-rtdb.firebaseio.com/";
const char*  FIREBASE_AUTH  = "b9C9nozAzPgX6SvPzaOoRa6eHuhPDOMuTjkHOicZ";
FirebaseData firebaseData;

void startWifiConnection(){
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    getBatteryPercentage();
    Serial.print(".");
    delay(9000);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();  
}

void firebaseInit(){
  Firebase.begin(FIREBASE_HOST,FIREBASE_AUTH);
  Firebase.reconnectWiFi(false);
  if(Firebase.ready()){
    Serial.println("Connected to firebase");
  }
}

void updateWifiMeasurements() {
  if(!startAxp192()) {
    setChargeLed(false);
    int moisture = getMoisturePercentage();
    int battery = getBatteryPercentage();
    WiFi.mode(WIFI_STA);
    startWifiConnection();
    firebaseInit();
    Firebase.setInt(firebaseData, "/users/208210896/humidity", moisture);
    Firebase.setInt(firebaseData, "/users/208210896/battery", battery);
    Firebase.end(firebaseData);
    WiFi.disconnect();
    setChargeLed(true);
    ESP.restart();
  }
}
#endif