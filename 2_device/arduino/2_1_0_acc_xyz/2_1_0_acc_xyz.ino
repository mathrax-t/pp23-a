#include <M5Core2.h>

//センサの情報をいれる変数
float accX = 0;
float accY = 0;
float accZ = 0;

void setup() {
  //M5の機能を使い始める
  M5.begin();
  //M5のセンサを使い始める
  //IMU（慣性計測ユニット。加速度センサとジャイロセンサ）
  M5.IMU.Init();

  //背景の色
  M5.Lcd.fillScreen(BLACK);
  //テキスト色、テキスト背景色
  M5.Lcd.setTextColor(WHITE, BLACK);
  //テキストサイズ
  M5.Lcd.setTextSize(2);

  //座標
  M5.Lcd.setCursor(160, 5);
  //文字
  M5.Lcd.print("SENSOR");
}

void loop() {
  //センサ情報を変数にいれる
  M5.IMU.getAccelData(&accX, &accY, &accZ);

  //加速度センサ X軸
  //座標
  M5.Lcd.setCursor(5, 5);
  //文字
  M5.Lcd.print("accX");
  //座標
  M5.Lcd.setCursor(80, 5);
  //変数を文字として
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
}
