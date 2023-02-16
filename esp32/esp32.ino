#include "WiFi.h"
// #define Server_Node
#define Sensor_Node
#define WIFI_MODE

void setup() {
  Serial.begin(115200);
  while (!Serial);
  startAxp192();
  // setChargeValues();
  // setCpuFrequencyMhz(80);
  // #ifdef Server_Node
  //   //serverNodeDeepSleep();
  // #else
  //   // sensorNodeDeepSleep();
  //   startWifiConnection();
  //   updateWifiMeasurements();
  //   sensorNodeDeepSleep();
  // #endif
}

void loop() {
 getBatteryPercentage();
 delay(3000);
}

