#include <M5Core2.h>

float accX = 0;
float accY = 0;
float accZ = 0;

void setup() {
  M5.begin();
  M5.IMU.Init();
  M5.Lcd.fillScreen(BLACK);
  M5.Lcd.setTextColor(WHITE, BLACK);
  M5.Lcd.setTextSize(2);

  M5.Lcd.setCursor(0, 10);
  M5.Lcd.printf("Sensor");
}

void loop() {
  M5.IMU.getAccelData(&accX, &accY, &accZ);

  M5.Lcd.setCursor(0, 70);
  M5.Lcd.print("accX");
  M5.Lcd.setCursor(0, 92);
  M5.Lcd.print(accX);

  M5.Lcd.setCursor(120, 70);
  M5.Lcd.print("accY");
  M5.Lcd.setCursor(120, 92);
  M5.Lcd.print(accY);

  M5.Lcd.setCursor(240, 70);
  M5.Lcd.print("accZ");
  M5.Lcd.setCursor(240, 92);
  M5.Lcd.print(accZ);

  delay(10);
}
