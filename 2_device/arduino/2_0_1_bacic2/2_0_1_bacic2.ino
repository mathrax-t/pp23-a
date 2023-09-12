#include <M5Core2.h>

void setup() {
  //M5の機能を使い始める
  M5.begin();
  
  //画面を塗りつぶす
  M5.Lcd.fillScreen(M5.Lcd.color565(50,50,100));

  //テキストサイズ
  M5.Lcd.setTextSize(2);  // 1~7 倍率
  //テキスト色、テキスト背景色
  M5.Lcd.setTextColor(M5.Lcd.color565(200,200,250), M5.Lcd.color565(50,50,100));
  
  //座標
  M5.Lcd.setCursor(160, 5);
  //文字
  M5.Lcd.print("YOUR NAME");
}

void loop() {
  //座標
  M5.Lcd.setCursor(5, 5);
  //文字
  M5.Lcd.print("X");

  //座標
  M5.Lcd.setCursor(5, 95);
  //文字
  M5.Lcd.print("Y");

  //座標
  M5.Lcd.setCursor(5, 185);
  //文字
  M5.Lcd.print("Z");
}
