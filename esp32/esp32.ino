#include "WiFi.h"
// #define WIFI_MODE
#define AP_MODE

enum mode {READ, VIEW};
mode boardMode;

void setup() {
  Serial.begin(115200);
  #ifdef WIFI_MODE
  updateWifiMeasurements();
  #else
  setupAPMode();
  #endif
}

void loop() {
 #ifdef AP_MODE
 updateAPMeasurements();
 #endif
}
