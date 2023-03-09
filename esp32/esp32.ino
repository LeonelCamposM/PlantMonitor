#include "WiFi.h"
#define DEBUG
#define SENSOR_NODE
#include <ArduinoJson.h>

#define uS_TO_S_FACTOR 1000000
#define TIME_TO_SLEEP  60
int counter = 0;

void goToSleep(){
  Serial.println("Going to deep sleep");
  esp_sleep_pd_config(ESP_PD_DOMAIN_RTC_PERIPH, ESP_PD_OPTION_OFF);
  esp_sleep_pd_config(ESP_PD_DOMAIN_RTC_SLOW_MEM, ESP_PD_OPTION_OFF);
  esp_sleep_pd_config(ESP_PD_DOMAIN_RTC_FAST_MEM, ESP_PD_OPTION_OFF);
  delay(2000);
  esp_deep_sleep_start();
} 

void setup() {
  #ifdef DEBUG
  Serial.begin(115200);
  while (!Serial);
  #endif

  #ifdef SENSOR_NODE 
    esp_sleep_enable_timer_wakeup(TIME_TO_SLEEP * uS_TO_S_FACTOR);   
    esp_sleep_wakeup_cause_t wakeup_reason;
    wakeup_reason = esp_sleep_get_wakeup_cause();

    if(!startLora()){
      StaticJsonDocument<200> message;
      if(!startBMP()){
        message["temperature"] = getBMPTemperature();
        message["pressure"] = getBMPPressure();
        message["altitude"] = getBMPAltitude();
      }
      if(!startAxp192()){
        message["battery"] = getBatteryPercentage();
      }
      message["humidity"] = getMoisturePercentage();

      String jsonString;
      serializeJson(message, jsonString);
      ackSendLora(String(jsonString));
      Serial.println("enviado " +jsonString);
      sleepLora();
    }
    goToSleep();
  #else

  #endif
}

void loop() {
}

