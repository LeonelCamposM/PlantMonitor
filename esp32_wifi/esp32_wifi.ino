#include "WiFi.h"
#include "FirebaseESP32.h"
#define WIFI_SSID "ARRIS-3215"
#define WIFI_PASSWORD "50A5DC803215"
#define TIME_INTERVAL 500
#define FIREBASE_HOST "https://plantmonitor-ec8fe-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "b9C9nozAzPgX6SvPzaOoRa6eHuhPDOMuTjkHOicZ"

FirebaseData firebaseData;

void startDevices(){
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
}

void scanWifiNetworks(){
  Serial.println("Looking for available networks");
  int availableNetworksCount = WiFi.scanNetworks();
  if (availableNetworksCount == 0) {
      Serial.println("No networks available");
  } else {
      Serial.print("Found ");
      Serial.print(availableNetworksCount);
      Serial.println(" available networks");
      for (int networkID = 0; networkID < availableNetworksCount; ++networkID) {
          Serial.print(networkID + 1);
          Serial.print(": ");
          Serial.print(WiFi.SSID(networkID));
          Serial.print(" (");
          Serial.print(WiFi.RSSI(networkID));
          Serial.print(")");
          Serial.println((WiFi.encryptionType(networkID) == WIFI_AUTH_OPEN)?" ":"*");
      }
  }
  Serial.println(" ");
}

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
  Firebase.reconnectWiFi(true);
  if(Firebase.ready()){
    Serial.println("Connected to firebase");
  }
  Firebase.setInt(firebaseData, "/humidity", 78);
  Firebase.end(firebaseData);
}
void setup()
{
  startDevices();
  startWifiConnection();
  firebaseInit();
  Serial.println("Finished succesfully");
}

void loop()
{
  // Serial.print("Run ");
  // delay(TIME_INTERVAL);
}