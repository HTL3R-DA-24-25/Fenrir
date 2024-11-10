#include "Wire.h"

#define SDA_PIN 21 // (I2C DATA)
#define SCL_PIN 22 // (I2C CLOCK)
#define TANK_PIN_1 35 // (ADC1-5)
#define TANK_PIN_2 34

#define I2C_SLAVE_ADDR 0x21
#define TOTAL_DATA_SIZE 2 // change when more data

struct Data {
  uint8_t tank1;
  uint8_t tank2;
};

void onRequest() {
  // reads the input on analog pin (value between 0 and 4095)
  int tank1Value = analogRead(TANK_PIN_1);
  int tank2Value = analogRead(TANK_PIN_2);

  struct Data data;
  data.tank1 = 3400 - tank1Value;
  data.tank2 = 3400 - tank2Value;

  Wire.write(0x02);
  Wire.write(TOTAL_DATA_SIZE + 4);

  char* c_arr = packData(data);
  for (int i = 0; i < TOTAL_DATA_SIZE; ++i) {
    Wire.write(c_arr[i]);
  }

  Serial.println(data.tank1);
  Serial.println(data.tank2);
  Wire.write(crc8((uint8_t*)c_arr, TOTAL_DATA_SIZE));
  Wire.write(0x04);
}

void onReceive(int len) {
  Serial.print("Received: ");

  while (Wire.available()) {
    char c = Wire.read();
    Serial.print((uint8_t)c);
    Serial.print(" ");
  }

  Serial.println("meow");
}

uint8_t crc8(uint8_t* data, int length) {
  uint8_t crc = 0;

  for (size_t i = 0; i < length; i++) {
    uint8_t extract = data[i];

    for (int j = 8; j > 0; j--) {
      uint8_t sum = (crc ^ extract) & 0x01;
      crc >>= 1;

      if (sum) {
        crc ^= 0x8C;
      }

      extract >>= 1;
    }
  }

  return crc;
}

char* packData(Data data) {
  char* c_arr = new char[TOTAL_DATA_SIZE];

  c_arr[0] = (char)data.tank1;
  c_arr[1] = (char)data.tank2;

  return c_arr;
}

void setup() {
  delay(500);

  Serial.begin(115200);
  Serial.setDebugOutput(true);

  bool res = Wire.begin((uint8_t)I2C_SLAVE_ADDR);
  if (!res) {
    Serial.println("I2C slave init failed");
    while (1) delay(100);
  }
  Serial.println("I2C slave init successful");

  Wire.onReceive(onReceive);
  Wire.onRequest(onRequest);
}

void loop() {}
