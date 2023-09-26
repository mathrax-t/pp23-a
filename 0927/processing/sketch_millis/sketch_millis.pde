long timer = 0;  //時間を覚えておく変数

void setup() {
  size(800, 600);
  timer = millis();  //timerに、現在時間を入れる
}

void draw() {
  if (millis() - timer > 500) {  //現在時間とtimerの差が、500ミリ秒を超えたら
    timer = millis();                  //timerに、現在時間を入れる
    background(random(255), random(255), random(255));
  }
}
