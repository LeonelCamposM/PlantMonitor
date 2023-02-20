#include "WiFi.h"
#define DEBUG

void setup() {
  #ifdef DEBUG
  Serial.begin(115200);
  while (!Serial);
  #endif

  if(!startAxp192()){
    #ifdef DEBUG
    getBatteryPercentage();
    #endif
    
    setupAPMode();
    setChargeLed(false);
  }
}

void loop() {
  updateAPMeasurements();
}

