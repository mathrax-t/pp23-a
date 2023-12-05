//クリックすると
//円がランダムなXY座標に出現して
//マウスの座標に向かって近づく
//マウスと円の座標の差が10より小さくなったら、
//円が消える

//じわじわと点に近づくプログラム
//参考
//サンプル＞Basics＞Input＞Easing

float energy = 0;
float en_x = 0;
float en_y = 0;
float x;
float y;
float my_x;
float my_y;
float easing = 0.05;

void setup() {
  size(800, 600);
  noStroke();
  //noCursor();
}

void draw() {
  background(0);

  energy -= 0.01;
  if (energy<0.0) {
    energy=0.0;
  }

  float targetX = my_x;
  float dx = targetX - en_x;
  en_x += dx * easing;

  float targetY = my_y;
  float dy = targetY - en_y;
  en_y += dy * easing;

  fill(255, 255*energy);
  ellipse(en_x, en_y, 10, 10);
}

void mousePressed() {
  en_x = random(0, width);
  en_y = random(0, height);
  energy = 1.0;
  my_x = mouseX;
  my_y = mouseY;
}
