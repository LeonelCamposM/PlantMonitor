#include "WiFi.h"
#define DEBUG
#define SENSOR_NODE
#include <ArduinoJson.h>
#include <ESP32Time.h>

#define MEASURE_PATH "/measure_data.txt"

#define uS_TO_S_FACTOR 1000000
#define TIME_TO_SLEEP 60
int counter = 0;
ESP32Time rtc(3600);
bool start_lora = false;

void goToSleep() {
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
  while (!Serial)
    ;
  rtc.setTime(00, 42, 18, 9, 03, 2023);
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
        setChargeValues();
        message["battery"] = getBatteryPercentage();
      }
      message["humidity"] = getMoisturePercentage();
      message["date"] = "today";

    String jsonString;
    serializeJson(message, jsonString);
    sendLora(String(jsonString));
    // ackSendLora(String(jsonString));
    Serial.println("enviado " + jsonString);
    sleepLora();
  }
  goToSleep();
#else

  start_lora = startLora();
  setupAPMode();

#endif
}

void loop() {
  if (!start_lora) {
    String packet = "";
    String date = rtc.getTime("%F %R");
    packet = receiveLora(date);
    Serial.println("[Server] arrived: " + packet);
  }
}
