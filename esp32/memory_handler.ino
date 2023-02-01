#include <EEPROM.h>

const int MEASURES_SIZE = 5;
const int EEPROM_SIZE = 2 + MEASURES_SIZE;
const int modeAddr = 0;
const int measureIndexAddr = 1;
const int firstMeasureAddr = 2;
int modeIdx;

void toggleMode() {
  EEPROM.write(modeAddr, modeIdx !=0 ? 0 : 1);
  EEPROM.commit();
}

// mode getCurrentMode() {
//   mode currentMode = READ;
//   modeIdx = EEPROM.read(modeAddr);
//   Serial.println(F("mode "+modeIdx));
//   toggleMode();
//   if(modeIdx != 0) {
//     currentMode = READ;
//   }else {
//     currentMode = VIEW;
//   }
//   return currentMode;
// }

bool initMemory() {
  bool error = false;
  if(!EEPROM.begin(EEPROM_SIZE)) {
    Serial.println(F("failed to initialize memory"));
    error = true;
  }

  // Serial.println("Memory: ");
  // for (int i = 0; i < MEASURES_SIZE +2; i++) {
  //   Serial.print(EEPROM.read(i));
  //   Serial.print(", ");
  // }
  return error;
}

void appendMeasure(int measure) {
  int measureIndex = EEPROM.read(measureIndexAddr);
  Serial.println("measure index :");
  Serial.println(measureIndex);
  EEPROM.write(measureIndex + 2, measure);
  EEPROM.commit();

  Serial.print("next : ");
  Serial.println(((measureIndex + 1) % MEASURES_SIZE));
  EEPROM.write(measureIndexAddr ,((measureIndex + 1) % MEASURES_SIZE));
  EEPROM.commit();
  for (int i = 0; i < MEASURES_SIZE; i++) {
    Serial.println(EEPROM.read(i+ 2));
  }
}

int getLastMeasure() {
  int measureIndex = EEPROM.read(measureIndexAddr);
  Serial.println("measure index :");
  Serial.println(measureIndex);

  int lastIndex = ((measureIndex - 1 + MEASURES_SIZE) % MEASURES_SIZE);
  Serial.println("last index :");
  Serial.println(lastIndex);

  int lastValue = EEPROM.read(lastIndex + 2);
  Serial.println("last value :");
  Serial.println(lastValue);
  return lastValue;
}
