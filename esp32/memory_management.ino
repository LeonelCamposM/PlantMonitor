#include <SPI.h>
#include <SD.h>
#include <RHSoftwareSPI.h>
#include <ArduinoJson.h>
#include <ESP32Time.h>

#define SD_CS 13
#define SD_SCK 14
#define SD_MOSI 15
#define SD_MISO 2
#define LOG_PATH "/measure_data.txt"

SPIClass sd_spi(HSPI);

bool remove_file() {
  bool response = false;
  sd_spi.begin(SD_SCK, SD_MISO, SD_MOSI, SD_CS);
  if (!SD.begin(SD_CS, sd_spi)) {
    Serial.println("SD Card: mounting failed.");
  } else {
    Serial.println("SD Card: mounted.");
    bool exist = SD.exists("/measure_data.txt");
    Serial.println("Sd exist: " + String(exist));
    if (exist) {
      response = SD.remove("/measure_data.txt");
    }
    sd_spi.end();
    SD.end();
  }
  return response;
}

void saveData(String data, String time) {
  sd_spi.begin(SD_SCK, SD_MISO, SD_MOSI, SD_CS);
  if (!SD.begin(SD_CS, sd_spi)) {
    Serial.println("SD Card: mounting failed.");
  } else {
    Serial.println("SD Card: mounted.");
    data.replace("today", time);
    data += ";";
    File dataFile;
    if (SD.exists(LOG_PATH)) {
      dataFile = SD.open(LOG_PATH, "a");
    } else {
      dataFile = SD.open(LOG_PATH, FILE_WRITE);
    }

    if (dataFile) {
      dataFile.println(data);
      dataFile.close();
      Serial.println("Saving data: ");
      Serial.println(data);
    }
    SD.end();
    sd_spi.end();
  }
}

String getAllData() {
  String response = "";
  sd_spi.begin(SD_SCK, SD_MISO, SD_MOSI, SD_CS);
  if (!SD.begin(SD_CS, sd_spi)) {
    Serial.println("SD Card: mounting failed.");
  } else {
    Serial.println("SD Card: mounted.");
    File dataFile = SD.open(LOG_PATH);
    if (dataFile) {
      while (dataFile.available()) {                   
        response += dataFile.readStringUntil('\n');  
      }
      dataFile.close();
    } else {
      Serial.println("error opening test.txt");
    }
    SD.end();
    sd_spi.end();
  }
  return response;
}
