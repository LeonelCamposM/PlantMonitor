#ifdef AP_MODE
const char* ssid = "PLANTMONITOR";
const char* password = "12345leo";
IPAddress local_IP(192,168,1,22);
IPAddress gateway(192,168,1,5);
IPAddress subnet(255,255,255,0);

void startAccesPoint(){
  WiFi.disconnect(false);
  WiFi.mode(WIFI_AP);
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
  setChargeLed(true);
  Serial.println("AP MODE");
  startAccesPoint();
  startHttpServer();
}

void updateAPMeasurements(){
  serverHandleClient(); 
  delay(1);
}
#endif