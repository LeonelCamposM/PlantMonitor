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
    // esp_sleep_wakeup_cause_t wakeup_reason;
    // wakeup_reason = esp_sleep_get_wakeup_cause();
    // switch(wakeup_reason)
    // {
    //   default: 
    //     setChargeLed(false);
    //     goToSleep();
    //   break;
    // }
  }
}

void loop() {
  updateAPMeasurements();
}

