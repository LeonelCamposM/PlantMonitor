#include <Wire.h>
#include <axp20x.h>
AXP20X_Class axp;

bool startAxp192() {
  bool error = false;
  Wire.begin(21, 22);
  if(axp.begin(Wire, AXP192_SLAVE_ADDRESS) == AXP_FAIL) {
    Serial.println(F("failed to initialize communication with AXP192"));
    error = true;
  }
  return error;
}

void setChargeValues() {
  axp.setChargeControlCur(AXP1XX_CHARGE_CUR_550MA);
  axp.setChargingTargetVoltage(AXP202_TARGET_VOL_4_2V);
  axp.enableChargeing(true);
}

void setChargeLed(bool value ) {
  if(value) {
    axp.setChgLEDMode(AXP20X_LED_LOW_LEVEL);
  }else{
    axp.setChgLEDMode(AXP20X_LED_OFF);
  }
}

int getBatteryPercentage() {
  Serial.println("Battery:");
  Serial.print(axp.getBattVoltage());
  Serial.println(" mV");
  int percentageBattery = map(axp.getBattVoltage(), 4000, 0, 100, 0);
  if(percentageBattery < 0) {
    percentageBattery = 0;
  }
   if(percentageBattery > 100) {
    percentageBattery = 100;
  }
  return percentageBattery;
}