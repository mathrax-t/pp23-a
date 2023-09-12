#include <M5Core2.h>

void setup() {
  //M5の機能を使い始める
  M5.begin();

  //画面を塗りつぶす
  M5.Lcd.fillScreen(M5.Lcd.color565(50, 50, 100));

  //まるをかく
  M5.Lcd.fillCircle(100, 100, 4, M5.Lcd.color565(100, 100, 150));
  //まるをかく
  M5.Lcd.fillCircle(220, 100, 4, M5.Lcd.color565(100, 100, 150));

  //さんかくをかく
  M5.Lcd.fillTriangle(100, 140, 160, 160, 220, 140, M5.Lcd.color565(150, 50, 50));

  // //おしゃれ演出
  // //バックライトふんわり
  // for (int i = 2500; i < 3300; i++) {
  //   M5.Axp.SetLcdVoltage(i);
  //   delay(2);
  // }
  // for (int i = 3300; i > 2900; i--) {
  //   M5.Axp.SetLcdVoltage(i);
  //   delay(2);
  // }
}

void loop() {
}
