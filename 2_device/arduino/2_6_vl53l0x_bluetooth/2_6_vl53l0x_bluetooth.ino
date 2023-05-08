#include <M5Core2.h>
#include <Wire.h>

#include "BluetoothSerial.h"
BluetoothSerial SerialBT;

#include "Adafruit_VL53L0X.h"
Adafruit_VL53L0X lox = Adafruit_VL53L0X();
int distance = 0;

float accX = 0;
float accY = 0;
float accZ = 0;


void setup() {
  Wire.begin();
  M5.begin();
  M5.IMU.Init();
  M5.Lcd.fillScreen(BLACK);
  M5.Lcd.setTextColor(WHITE, BLACK);
  M5.Lcd.setTextSize(2);

  SerialBT.begin("TAMABI_IDDtest");  //Bluetooth device name

  M5.Lcd.setCursor(0, 10);
  M5.Lcd.print("Sensor");
  M5.Lcd.print(" Send via USB");
  M5.Lcd.print(" & BT");

  Serial.begin(9600);

  lox.begin();
  lox.startRangeContinuous();
}

void loop() {
  M5.IMU.getAccelData(&accX, &accY, &accZ);
  // M5.Lcd.clear();

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

  if (lox.isRangeComplete()) {
    distance = lox.readRange();
    M5.Lcd.setCursor(0, 150);
    M5.Lcd.print("Distance in mm:");
    M5.Lcd.setCursor(240, 150); //いったん数値のうしろを消す(4ケタなので4コの空白)
    M5.Lcd.print("    ");
    M5.Lcd.setCursor(240, 150); //距離の数値を表示する
    M5.Lcd.print(distance);
  }



  // To Processing
  // via USB
  Serial.print(accX);
  Serial.print(",");
  Serial.print(accY);
  Serial.print(",");
  Serial.print(accZ);
  Serial.print(",");            //距離センサ情報を追加
  Serial.print(distance);       //
  Serial.println();

  // via Bluetooth
  SerialBT.print(accX);
  SerialBT.print(",");
  SerialBT.print(accY);
  SerialBT.print(",");
  SerialBT.print(accZ);
  SerialBT.print(",");            //距離センサ情報を追加
  SerialBT.print(distance);       //
  SerialBT.println();

  delay(10);
}
