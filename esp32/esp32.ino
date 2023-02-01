#include "WiFi.h"
// #define WIFI_MODE
#define AP_MODE

void batteryMonitorTask(void *pvParameter) {
  while (1) {
    if (getBatteryVoltage() >= 4100) {
      Serial.println("charged");
      stopCharging();
    }
    if(getBatteryVoltage() <= 2600){
      Serial.println("charging");
      setChargeValues();
    }
    vTaskDelay(40000 / portTICK_PERIOD_MS);
  }
}

void callback(){
}

int print_wakeup_reason(){
  esp_sleep_wakeup_cause_t wakeup_reason;
  int reason_id = 0;

  wakeup_reason = esp_sleep_get_wakeup_cause();

  switch(wakeup_reason)
  {
    case ESP_SLEEP_WAKEUP_TIMER : Serial.println("Wakeup caused by timer");
      reason_id = 1;
      break;
    case ESP_SLEEP_WAKEUP_TOUCHPAD : Serial.println("Wakeup caused by touchpad"); 
      reason_id = 2;
      break;
    default : Serial.printf("Wakeup was not caused by deep sleep: %d\n",wakeup_reason); 
      reason_id = 0;
      break;
  }
  return reason_id;
}

void setup() {
  Serial.begin(115200);
  delay(1000);

  if(!startAxp192()) {
    //xTaskCreate(batteryMonitorTask, "BatteryMonitorTask", 2048, NULL, 1, NULL);
    stopCharging();
    touchAttachInterrupt(T2, callback, 30);
    esp_sleep_enable_touchpad_wakeup();

    esp_sleep_wakeup_cause_t wakeup_reason;
    wakeup_reason = esp_sleep_get_wakeup_cause();
    switch(wakeup_reason)
    {
      case ESP_SLEEP_WAKEUP_TOUCHPAD : 
        Serial.println("Wakeup caused by touchpad"); 
        getBatteryPercentage();
        #ifdef WIFI_MODE
        updateWifiMeasurements();
        #else
        setupAPMode();
        #endif
      break;

      default : 
        Serial.println("Going to deep sleep with: ");
        getBatteryPercentage();
        setChargeLed(false);
        WiFi.disconnect(true);
        WiFi.mode(WIFI_OFF);
        esp_deep_sleep_start();
      break;
    }
  }
}

void loop() {
 #ifdef AP_MODE
 updateAPMeasurements();
 #endif
}
