#define uS_TO_S_FACTOR 1000000
#define TIME_TO_SLEEP  60
int counter = 0;

void goToSleep(){
  Serial.println("Going to deep sleep");
  esp_sleep_pd_config(ESP_PD_DOMAIN_RTC_PERIPH, ESP_PD_OPTION_OFF);
  esp_sleep_pd_config(ESP_PD_DOMAIN_RTC_SLOW_MEM, ESP_PD_OPTION_OFF);
  esp_sleep_pd_config(ESP_PD_DOMAIN_RTC_FAST_MEM, ESP_PD_OPTION_OFF);
  esp_deep_sleep_start();
} 

void sensorNodeDeepSleep(){
  if(!startLora() && !startAxp192()){
    esp_sleep_enable_timer_wakeup(TIME_TO_SLEEP * uS_TO_S_FACTOR);   
    esp_sleep_wakeup_cause_t wakeup_reason;
    wakeup_reason = esp_sleep_get_wakeup_cause();
    String number = "";
    String ack = "";

    switch(wakeup_reason)
    {
      case ESP_SLEEP_WAKEUP_TIMER :
        Serial.println("Wakeup caused by timer sending lora random"); 
        number = String(getBatteryPercentage());
        ackSendLora("batt: " + number+ "moist: " + String(getMoisturePercentage()));
        sleepLora();
        goToSleep();
      break;

      default : 
        getBatteryPercentage();
        goToSleep();
      break;
    }
  }
}

void listenLoraRequest(){
  while (true){
    String packet = "";
    packet = receiveLora();
    Serial.println("[Server] arrived: "+ packet);
    sendLora(packet);
    Serial.println("[Server] sending ack");
  }
}

void serverNodeDeepSleep(){
  if(!startLora() && !startAxp192()){
    getBatteryPercentage();
    esp_sleep_enable_timer_wakeup(TIME_TO_SLEEP * uS_TO_S_FACTOR);  
    esp_sleep_wakeup_cause_t wakeup_reason;
    wakeup_reason = esp_sleep_get_wakeup_cause();
    switch(wakeup_reason)
    {
      case ESP_SLEEP_WAKEUP_TIMER: 
        Serial.println("Wakeup caused by timer Listening for lora sensors");
        setChargeLed(false);
        listenLoraRequest();
        Serial.println("Done listening");
      break;

      default: 
        setChargeLed(false);
        goToSleep();
      break;
    }
  }
}