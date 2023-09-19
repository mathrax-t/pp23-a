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
  M5.Lcd.print("GROUP NAME");
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

  //センサ情報を幅として四角を描く
  int ax = map(accX*100, 100, -100, 0, 320);
  M5.Lcd.fillRect(ax, 35, 320 - ax, 10, DARKGREY); //灰色の四角
  M5.Lcd.fillRect(0, 35, ax, 10, RED);  //赤い四角


  //加速度センサ Y軸
  M5.Lcd.setCursor(5, 95);
  M5.Lcd.print("accY");
  M5.Lcd.setCursor(80, 95);
  M5.Lcd.print(accY);
  int ay = map(accY*100, 100, -100, 0, 320);
  M5.Lcd.fillRect(ay, 125, 320 - ay, 10, DARKGREY); //灰色の四角
  M5.Lcd.fillRect(0, 125, ay, 10, GREEN); //緑の四角

  //加速度センサ Z軸
  M5.Lcd.setCursor(5, 185);
  M5.Lcd.print("accZ");
  M5.Lcd.setCursor(80, 185);
  M5.Lcd.print(accZ);
  int az = map(accZ*100, 100, -100, 0, 320);
  M5.Lcd.fillRect(az, 215, 320 - az, 10, DARKGREY); //灰色の四角
  M5.Lcd.fillRect(0, 215, az, 10, CYAN); //水色の四角
}
