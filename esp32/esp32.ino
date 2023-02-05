#include "WiFi.h"
#define WIFI_MODE

// #define AP_MODE

#define uS_TO_S_FACTOR 1000000
#define TIME_TO_SLEEP  10   

void callback(){
}

void goToSleep(){
  Serial.println("Going to deep sleep with: ");
  setChargeLed(false);
  WiFi.disconnect(true);
  WiFi.mode(WIFI_OFF);
  esp_deep_sleep_start();
}

void setup() {
  Serial.begin(115200);
  delay(1000);

  if(!startAxp192()) {
    getBatteryPercentage();

    #ifdef WIFI_MODE
      esp_sleep_enable_timer_wakeup(TIME_TO_SLEEP * uS_TO_S_FACTOR);
    #else
      touchAttachInterrupt(T2, callback, 70);
      esp_sleep_enable_touchpad_wakeup();
    #endif

    esp_sleep_wakeup_cause_t wakeup_reason;
    wakeup_reason = esp_sleep_get_wakeup_cause();
    switch(wakeup_reason)
    {
      #ifdef AP_MODE
      case ESP_SLEEP_WAKEUP_TOUCHPAD : 
        Serial.println("Wakeup caused by touchpad"); 
        setupAPMode();
      break;
      #endif
      
      case ESP_SLEEP_WAKEUP_TIMER :
        Serial.println("Wakeup caused by timer"); 
        updateWifiMeasurements();
        goToSleep();
      break;

      default : 
        goToSleep();
      break;
    }
  }
}

void loop() {
 #ifdef AP_MODE
 updateAPMeasurements();
 #endif
}
