#include <M5Core2.h>
#include "BluetoothSerial.h"

float accX = 0;
float accY = 0;
float accZ = 0;

BluetoothSerial SerialBT;

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
 M5.Lcd.printf(" & BT");

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


 // To Processing
 // via USB
 Serial.print(accX);
 Serial.print(",");
 Serial.print(accY);
 Serial.print(",");
 Serial.print(accZ);
 Serial.println();

 // via Bluetooth
 SerialBT.print(accX);
 SerialBT.print(",");
 SerialBT.print(accY);
 SerialBT.print(",");
 SerialBT.print(accZ);
 SerialBT.println();

 delay(10);
}

