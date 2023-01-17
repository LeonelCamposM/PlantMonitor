enum mode {READ, VIEW};
mode boardMode;

void setup() {
  Serial.begin(115200);
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
        // stopAccesPoint();
        getMoisturePercentage(); // TODO append new value to eprom memory
        startAccesPoint();
        startHttpServer();
      } break;
    }
  }
}

void loop() {
  switch (boardMode) {
    case READ: {
      getMoisturePercentage(); // TODO append new value to eprom memory
      delay(2000);
    } break;
    case VIEW: {
      serverHandleClient(); 
      delay(1);
    } break;
  }
}
