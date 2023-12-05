int maxKurukuru = 100;
Kurukuru[] kuru = new Kurukuru[maxKurukuru];
int count = 0;

// 画像
PImage star;


void setup() {
  size(800, 600);
  //fullScreen();

  //画像読込み
  star = loadImage("star.png");
  for (int i=0; i<maxKurukuru; i++) {
    kuru[i] = new Kurukuru();
  }
}

void draw() {
  noStroke();
  fill(0, 50);
  rect(0, 0, width, height);

  for (int i=0; i<maxKurukuru; i++) {
    kuru[i].update();
  }
}

void mouseMoved() {
  if (frameCount%int(random(5, 20))==0) {
    kuru[count % maxKurukuru].action();
    count++;
  }
}


// Kurukuru class ----------------------------------------------------
class Kurukuru {
  //サインコサイン用
  float t = 0;
  //動く時間
  float move_time = 0;
  //透明度
  float transparent = 0;
  //動く時間のリミット
  float limit = 0.1;
  //回転角度
  float angle = 0.0;


  void update() {
    t+=0.075;
    noStroke();

    //HSBモード
    colorMode(HSB);
    //画像に色フィルタ
    //色のモードはHSB
    //（色相、彩度、明度、透明度）
    tint(random(20, 40), random(255), 255, 255*transparent);

    //座標をいったんおいといて
    push();
    //原点を移動
    translate(width/2 -sin(t)*200, height/2 +cos(t)*200);
    //大きさを変更
    scale(random(1));
    //回転
    rotate(radians(angle+frameCount*10));
    //画像を描く
    image(star, 0, 0);
    //座標を反映
    pop();

    //fill(random(60, 120), random(255), 255, 255*transparent);
    //ellipse(
    //  width/2+sin(t)*200,
    //  height/2+cos(t)*200,
    //  20,
    //  20
    //  );

    //動く時間を徐々に減らす
    move_time *= 0.95;
    //動く時間がリミットより小さくなったら
    if (move_time < limit) {
      //透明度を減らす
      transparent *= 0.9;
    }
  }

  void action() {
    //サインコサインがランダムになるように
    t = random(0, TWO_PI);
    //動く時間を4.0に
    move_time = 4.0;
    //透明度を1.0に
    transparent = 1.0;
    //動く時間のリミットを0.1~0.5に
    limit = random(0.1, 0.5);
    //回転角度をランダムに
    angle = random(0,360);
  }
}
