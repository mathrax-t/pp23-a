#include <M5Core2.h>

#include "BluetoothSerial.h"
BluetoothSerial SerialBT;

float accX = 0;
float accY = 0;
float accZ = 0;

#include "Ultrasonic.h"
Ultrasonic ultrasonic(33);  //33番ピンで読みとる
int distance = 0;

void setup() {
  M5.begin();
  M5.IMU.Init();
  M5.Lcd.fillScreen(BLACK);
  M5.Lcd.setTextColor(WHITE, BLACK);
  M5.Lcd.setTextSize(2);

  SerialBT.begin("TAMABI_IDDtest");  //Bluetooth device name

  M5.Lcd.setCursor(0, 10);
  M5.Lcd.printf("Sensor");
  M5.Lcd.printf(" Send via USB");

  Serial.begin(9600);
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


  distance = ultrasonic.MeasureInCentimeters();
  M5.Lcd.setCursor(0, 150);
  M5.Lcd.print("Distance in cm:");
  M5.Lcd.setCursor(240, 150);  //いったん数値のうしろを消す(4ケタなので4コの空白)
  M5.Lcd.print("    ");
  M5.Lcd.setCursor(240, 150);  //距離の数値を表示する
  M5.Lcd.print(distance);


  // To Processing
  // via USB
  Serial.print(accX);
  Serial.print(",");
  Serial.print(accY);
  Serial.print(",");
  Serial.print(accZ);
  Serial.print(",");       //距離センサ情報を追加
  Serial.print(distance);  //
  Serial.println();

  // via Bluetooth
  SerialBT.print(accX);
  SerialBT.print(",");
  SerialBT.print(accY);
  SerialBT.print(",");
  SerialBT.print(accZ);
  SerialBT.print(",");       //距離センサ情報を追加
  SerialBT.print(distance);  //
  SerialBT.println();

  delay(10);
}
