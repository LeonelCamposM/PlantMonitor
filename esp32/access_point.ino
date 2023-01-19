#ifdef AP_MODE
const char* ssid = "PLANTMONITOR";
const char* password = "12345leo";
IPAddress local_IP(192,168,1,22);
IPAddress gateway(192,168,1,5);
IPAddress subnet(255,255,255,0);

void startAccesPoint() {
  Serial.print("Setting up Access Point ... ");
  Serial.println(WiFi.softAPConfig(local_IP, gateway, subnet) ? "Ready" : "Failed!");

  Serial.print("Starting Access Point ... ");
  Serial.println(WiFi.softAP(ssid, password) ? "Ready" : "Failed!");

  Serial.print("IP address = ");
  Serial.println(WiFi.softAPIP());
}

void stopAccesPoint(){
  WiFi.softAPdisconnect (true);
}

void setupAPMode(){
  if(!startAxp192() && !initMemory()) {
    boardMode = getCurrentMode();
    switch (boardMode) {
      case READ: {
        Serial.println("READ MODE");
        setChargeLed(false);
      } break;
      case VIEW: {
        Serial.println("AP MODE");
        setChargeLed(true);
        // appendMeasure(getMoisturePercentage());
        startAccesPoint();
        startHttpServer();
      } break;
    }
  }
}

void updateAPMeasurements(){
  switch (boardMode) {
    case READ: {
      appendMeasure(getMoisturePercentage());
      delay(9000);
    } break;
    case VIEW: {
      serverHandleClient(); 
      delay(1);
    } break;
  }
}
#endif