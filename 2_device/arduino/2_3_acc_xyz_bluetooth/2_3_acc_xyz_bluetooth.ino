#include <M5Core2.h>

//Bluetoothライブラリを読込む
#include "BluetoothSerial.h"
//Bluetoothを管理する変数
BluetoothSerial SerialBT;

//センサの情報をいれる変数
float accX = 0;
float accY = 0;
float accZ = 0;

void setup() {
  //M5の機能を使い始める
  M5.begin();
  //M5のセンサを使い始める
  M5.IMU.Init();

  //背景の色
  M5.Lcd.fillScreen(BLACK);
  M5.Lcd.setTextColor(WHITE, BLACK);
  M5.Lcd.setTextSize(2);

  //座標と文字
  M5.Lcd.setCursor(160, 5);
  M5.Lcd.print("SENSOR+USB+BT");

  //PCとの通信を始める
  Serial.begin(9600);

  //Bluetooth通信をはじめる
  //オリジナルのデバイス名を決めてください
  SerialBT.begin("TAMABI_IDDtest");  
}

void loop() {
  //センサ情報を変数にいれる
  M5.IMU.getAccelData(&accX, &accY, &accZ);

  //加速度センサ X軸
  M5.Lcd.setCursor(5, 5);
  M5.Lcd.print("accX");
  M5.Lcd.setCursor(80, 5);
  M5.Lcd.print(accX);

  //加速度センサ Y軸
  M5.Lcd.setCursor(5, 95);
  M5.Lcd.print("accY");
  M5.Lcd.setCursor(80, 95);
  M5.Lcd.print(accY);

  //加速度センサ Z軸
  M5.Lcd.setCursor(5, 185);
  M5.Lcd.print("accZ");
  M5.Lcd.setCursor(80, 185);
  M5.Lcd.print(accZ);


  //PCにデータを送信する（USBで）
  //変数をコンマ区切りにして送る
  Serial.print(accX);
  Serial.print(",");
  Serial.print(accY);
  Serial.print(",");
  Serial.print(accZ);
  Serial.println();  //最後は改行を送る

  //Bluetoothでデータを送信
  //変数をコンマ区切りにして送る
  SerialBT.print(accX);
  SerialBT.print(",");
  SerialBT.print(accY);
  SerialBT.print(",");
  SerialBT.print(accZ);
  SerialBT.println();  //最後は改行を送る

  //データを送りすぎるので、少し遅らせる
  delay(10);
}
