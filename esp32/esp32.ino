#include "WiFi.h"
// #define Server_Node
#define Sensor_Node

void setup() {
  Serial.begin(115200);
  while (!Serial);

  #ifdef Server_Node
    serverNodeDeepSleep();
  #else
    sensorNodeDeepSleep();
  #endif
}

void loop() {
}

