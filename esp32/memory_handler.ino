#include <EEPROM.h>
#define EEPROM_SIZE 1

const int modeAddr = 0;
int modeIdx;

void toggleMode() {
  EEPROM.write(modeAddr, modeIdx !=0 ? 0 : 1);
  EEPROM.commit();
}

mode getCurrentMode() {
  mode currentMode = READ;
  modeIdx = EEPROM.read(modeAddr);
  toggleMode();
  if(modeIdx != 0) {
    currentMode = READ;
  }else {
    currentMode = VIEW;
  }
  return currentMode;
}

bool initMemory() {
  bool error = false;
  if(!EEPROM.begin(EEPROM_SIZE)) {
    Serial.println(F("failed to initialize memory"));
    error = true;
  }
  return error;
}