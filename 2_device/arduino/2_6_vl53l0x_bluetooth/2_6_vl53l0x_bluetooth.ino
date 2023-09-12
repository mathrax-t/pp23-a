#include <M5Core2.h>

//Bluetoothライブラリを読込む
#include "BluetoothSerial.h"
//Bluetoothを管理する変数
BluetoothSerial SerialBT;

float accX = 0;
float accY = 0;
float accZ = 0;

//距離センサのライブラリを読込み
#include "Adafruit_VL53L0X.h"
//距離センサを管理する変数
Adafruit_VL53L0X lox = Adafruit_VL53L0X();
//距離を入れる変数
int distance = 0;


void setup() {
  //M5の機能を使い始める
  M5.begin();
  //M5のセンサを使い始める
  M5.IMU.Init();

  //背景の色など
  M5.Lcd.fillScreen(BLACK);
  M5.Lcd.setTextColor(WHITE, BLACK);
  M5.Lcd.setTextSize(2);

  //座標と文字
  M5.Lcd.setCursor(160, 5);
  M5.Lcd.print("SENSOR+USB+BT");

  //PCとの通信を始める
  Serial.begin(9600);

  //距離センサを使い始める
  lox.begin();
  lox.startRangeContinuous();

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
  int ax = mapRange(accX, 1, -1, 0, 320);
  M5.Lcd.fillRect(ax, 35, 320 - ax, 10, DARKGREY);  //灰色の四角
  M5.Lcd.fillRect(0, 35, ax, 10, RED);              //赤い四角


  //加速度センサ Y軸
  M5.Lcd.setCursor(5, 65);
  M5.Lcd.print("accY");
  M5.Lcd.setCursor(80, 65);
  M5.Lcd.print(accY);
  int ay = mapRange(accY, 1, -1, 0, 320);
  M5.Lcd.fillRect(ay, 95, 320 - ay, 10, DARKGREY);  //灰色の四角
  M5.Lcd.fillRect(0, 95, ay, 10, GREEN);            //緑の四角

  //加速度センサ Z軸
  M5.Lcd.setCursor(5, 125);
  M5.Lcd.print("accZ");
  M5.Lcd.setCursor(80, 125);
  M5.Lcd.print(accZ);
  int az = mapRange(accZ, 1, -1, 0, 320);
  M5.Lcd.fillRect(az, 155, 320 - az, 10, DARKGREY);  //灰色の四角
  M5.Lcd.fillRect(0, 155, az, 10, CYAN);             //水色の四角


  //距離センサ
  if (lox.isRangeComplete()) {
    distance = lox.readRange();
    M5.Lcd.setCursor(5, 190);
    M5.Lcd.print("Distance in mm:");
    M5.Lcd.setCursor(240, 190);  //いったん数値のうしろを消す(4ケタなので4コの空白)
    M5.Lcd.print("    ");
    M5.Lcd.setCursor(240, 190);  //距離の数値を表示する
    M5.Lcd.print(distance);

    int ad = mapRange(distance, 0, 1200, 0, 320);
    M5.Lcd.fillRect(ad, 220, 320 - ad, 10, DARKGREY);  //灰色の四角
    M5.Lcd.fillRect(0, 220, ad, 10, YELLOW);           //黄色の四角
  }

  //PCにデータを送信する（USBで）
  //変数をコンマ区切りにして送る
  Serial.print(accX);
  Serial.print(",");
  Serial.print(accY);
  Serial.print(",");
  Serial.print(accZ);
  Serial.print(",");
  Serial.print(distance);  //距離センサを追加
  Serial.println();        //最後は改行を送る
  
  //Bluetoothでデータを送信
  //変数をコンマ区切りにして送る
  SerialBT.print(accX);
  SerialBT.print(",");
  SerialBT.print(accY);
  SerialBT.print(",");
  SerialBT.print(accZ);
  SerialBT.print(",");
  SerialBT.print(distance);  //距離センサを追加
  SerialBT.println();  //最後は改行を送る

  //データを送りすぎるので、少し遅らせる
  delay(10);
}

// mapがうまく機能しなかったので、関数を用意しました
float mapRange(float value, float a, float b, float c, float d) {
  value = (value - a) / (b - a);
  return c + value * (d - c);
}
