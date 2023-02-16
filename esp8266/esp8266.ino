#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

const char*  WIFI_SSID = "ARRIS-3215";
const char*  WIFI_PASSWORD = "50A5DC803215";
const String apiKey = "8965126";
String phoneNumber = "50683355317";
String url;

const int moisturePin = A0;
int maxMoisture = 712  ; // dry 
int minMoisture = 300; // wet

int getMoisturePercentage() {
  int sensorValue = analogRead(moisturePin);
  int percentageHumidity = map(sensorValue, minMoisture, maxMoisture, 100, 0);
  if(percentageHumidity < 0 || sensorValue == 0) {
    percentageHumidity = 0;
  }
  if(percentageHumidity > 100) {
    percentageHumidity = 100;
  }
  Serial.print("Moisture: "); 
  Serial.print(sensorValue); 
  Serial.print(" percentage: ");
  Serial.print(percentageHumidity);
  Serial.println("");
  return percentageHumidity;
}

void sendMessage(String message){
  // Data to send with HTTP POST
  String url = "http://api.callmebot.com/whatsapp.php?phone=" + phoneNumber + "&apikey=" + apiKey + "&text=" + message;
  WiFiClient client;    
  HTTPClient http;
  http.begin(client, url);

  // Specify content-type header
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");
  
  // Send HTTP POST request
  int httpResponseCode = http.POST(url);
  if (httpResponseCode == 200){
    Serial.print("Message sent successfully");
  }
  else{
    Serial.println("Error sending the message");
    Serial.print("HTTP response code: ");
    Serial.println(httpResponseCode);
  }

  // Free resources
  http.end();
}

void setup() { 
  Serial.begin(115200);
  while (!Serial);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);             // Connect to the network
  Serial.print("Connecting to ");
  Serial.print(WIFI_SSID); Serial.println(" ...");

  int i = 0;
  while (WiFi.status() != WL_CONNECTED) { // Wait for the Wi-Fi to connect
    delay(1000);
    Serial.print(++i); Serial.print(' ');
  }

  Serial.println('\n');
  Serial.println("Connection established!");  
  Serial.print("IP address:\t");
  Serial.println(WiFi.localIP());  
  Serial.println("Sending message");
  sendMessage("Humedad:+"+String(getMoisturePercentage())); 
  Serial.println("Modo ESP8266 deep sleep durante 10 segundos");
  delay(20000);
  ESP.deepSleep(20e6); 
}

void loop() {
}

