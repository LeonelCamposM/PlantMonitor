#include "WiFi.h"
#include "FirebaseESP32.h"
// #define WIFI_SSID "ARRIS-3215"
// #define WIFI_PASSWORD "50A5DC803215"
#define WIFI_SSID "ARRIS-3215"
#define WIFI_PASSWORD "50A5DC803215"
#define TIME_INTERVAL 500
#define FIREBASE_HOST "https://plantmonitor-ec8fe-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "b9C9nozAzPgX6SvPzaOoRa6eHuhPDOMuTjkHOicZ"

enum mode {READ, VIEW};
mode boardMode;
FirebaseData firebaseData;

void startWifiConnection(){
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
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

void updateSensorValues() {
  int moisture = getMoisturePercentage();
  int battery = getBatteryPercentage();
  WiFi.mode(WIFI_STA);
  startWifiConnection();
  firebaseInit();
  Firebase.setInt(firebaseData, "/users/208210896/humidity", moisture);
  Firebase.setInt(firebaseData, "/users/208210896/battery", battery);
  Firebase.end(firebaseData);
  WiFi.disconnect();
}

void setup() {
  Serial.begin(115200);
  if(!startAxp192() && !initMemory()) {
    setChargeLed(false);
    // boardMode = getCurrentMode();
    updateSensorValues();
    delay(4000);
    ESP.restart();
    //firebaseInit();
    // switch (boardMode) {
    //   case READ: {
    //     Serial.println("READ MODE");
    //     setChargeLed(false);
    //   } break;
    //   case VIEW: {
    //     Serial.println("AP MODE");
    //     setChargeLed(true);
    //     getMoisturePercentage(); // TODO append new value to eprom memory
    //     startAccesPoint();
    //     startHttpServer();
    //   } break;
    // }
  }
}

void loop() {
  // switch (boardMode) {
  //   case READ: {
  //     getMoisturePercentage(); // TODO append new value to eprom memory
  //     delay(2000);
  //   } break;
  //   case VIEW: {
  //     serverHandleClient(); 
  //     delay(1);
  //   } break;
  // }
}
