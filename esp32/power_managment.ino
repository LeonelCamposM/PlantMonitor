#include <Wire.h>
#include <axp20x.h>
AXP20X_Class axp;

bool startAxp192() {
  bool error = false;
  Wire.begin(21, 22);
  if(axp.begin(Wire, AXP192_SLAVE_ADDRESS) != AXP_FAIL) {
    setChargeValues();
    setChargeLed(false);
  }
  return error;
}

void setChargeValues() {
  axp.setChargeControlCur(AXP1XX_CHARGE_CUR_550MA);
  axp.setChargingTargetVoltage(AXP202_TARGET_VOL_4_2V);
  axp.enableChargeing(true);
}

void stopCharging() {
  axp.enableChargeing(false);
}

void setChargeLed(bool value ) {
  if(value) {
    axp.setChgLEDMode(AXP20X_LED_LOW_LEVEL);
  }else{
    axp.setChgLEDMode(AXP20X_LED_OFF);
  }
}

int getBatteryPercentage() {
  #ifdef DEBUG
  Serial.println("Battery:");
  Serial.print(axp.getBattVoltage());
  Serial.println(" mV");
  #endif
  
  int percentageBattery = map(axp.getBattVoltage(), 4200, 2600, 100, 0);
  if(percentageBattery < 0) {
    percentageBattery = 0;
  }
  if(percentageBattery > 100) {
    percentageBattery = 100;
  }
  return percentageBattery;
}

int getBatteryVoltage(){
  return axp.getBattVoltage();
}
