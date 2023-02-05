#ifdef WIFI_MODE
#include "FirebaseESP32.h"
#include "time.h"

const char*  WIFI_SSID = "ARRIS-3215";
const char*  WIFI_PASSWORD = "50A5DC803215";
const char* FIREBASE_HOST  = "https://plantmonitor-ec8fe-default-rtdb.firebaseio.com/";
const char*  FIREBASE_AUTH  = "b9C9nozAzPgX6SvPzaOoRa6eHuhPDOMuTjkHOicZ";
FirebaseData firebaseData;

void startWifiConnection() {
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(9000);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();  
}

void firebaseInit() {
  Firebase.begin(FIREBASE_HOST,FIREBASE_AUTH);
  Firebase.reconnectWiFi(false);
  if(Firebase.ready()) {
    Serial.println("Connected to firebase");
  }
}

void updateWifiMeasurements() {
  const char* ntpServer = "pool.ntp.org";
  const long  gmtOffset_sec = -21600;
  const int   daylightOffset_sec = 0;
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  
  setChargeLed(false);
  int moisture = getMoisturePercentage();
  int battery = getBatteryPercentage();
  startWifiConnection();
  struct tm timeinfo;
  char buffer[80];
  char buffer2[80];
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
  }else{
    strftime(buffer, sizeof(buffer), "%Y-%B-%d", &timeinfo);
    strftime(buffer2, sizeof(buffer2), "%H:%M", &timeinfo);
  }
  firebaseInit();
  Firebase.setInt(firebaseData, "/users/leonel/Sur/Humedad", moisture);
  Firebase.setInt(firebaseData, "/users/leonel/Sur/Bateria", battery);
  Firebase.setString(firebaseData, "/users/leonel/Sur/Fecha", buffer);
  Firebase.setString(firebaseData, "/users/leonel/Sur/Hora", buffer2);
  Firebase.end(firebaseData);
  WiFi.disconnect();
  setChargeLed(true);
}
#endif