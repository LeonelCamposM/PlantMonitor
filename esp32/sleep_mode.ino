#define uS_TO_S_FACTOR 1000000
#define TIME_TO_SLEEP  10   
int counter = 0;

void goToSleep(){
  Serial.println("Going to deep sleep with: ");
  // setChargeLed(false);
  WiFi.disconnect(true);
  WiFi.mode(WIFI_OFF);
  esp_deep_sleep_start();
}

void sensorNodeDeepSleep(){
  if(!startLora()){
    esp_sleep_enable_timer_wakeup(120 * uS_TO_S_FACTOR);   
    esp_sleep_wakeup_cause_t wakeup_reason;
    wakeup_reason = esp_sleep_get_wakeup_cause();
    String number = "";
    String ack = "";

    switch(wakeup_reason)
    {
      case ESP_SLEEP_WAKEUP_TIMER :
        Serial.println("Wakeup caused by timer sending lora random"); 
        number = String(random(1,100));
        ackSendLora("Datos: " + number);
        goToSleep();
      break;

      default : 
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
      case ESP_SLEEP_WAKEUP_TIMER : 
        Serial.println("Wakeup caused by timer Listening for lora sensors");
        setChargeLed(true);
        listenLoraRequest();
        Serial.println("Done listening");
      break;

      default : 
        goToSleep();
      break;
    }
  }
}