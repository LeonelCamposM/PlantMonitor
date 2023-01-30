#include "WiFi.h"
// #define WIFI_MODE
#define AP_MODE

enum mode {READ, VIEW};
mode boardMode;

void batteryMonitorTask(void *pvParameter) {
  while (1) {
    Serial.println("Thread monitoring");
    if (getBatteryVoltage() >= 4083) {
      Serial.println("charged");
      stopCharging();
    }
    if(getBatteryVoltage() <= 2030){
      Serial.println("charging");
      setChargeValues();
    }
    vTaskDelay(40000 / portTICK_PERIOD_MS);
  }
}

void setup() {
  Serial.begin(115200);
  if(!startAxp192()) {
    xTaskCreate(batteryMonitorTask, "BatteryMonitorTask", 2048, NULL, 1, NULL);
    #ifdef WIFI_MODE
    updateWifiMeasurements();
    #else
    setupAPMode();
    #endif
  }
}

void loop() {
 #ifdef AP_MODE
 updateAPMeasurements();
 #endif
}
