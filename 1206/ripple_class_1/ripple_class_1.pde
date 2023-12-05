//同時に表示する波紋の数
int maxRipple = 100;    

//波紋オブジェクト用変数
Ripple[] rp = new Ripple[maxRipple];
//波紋オブジェクトを次に進めるために数える変数
int r_count = 0;


void setup() {
  size(800, 600);
  noiseDetail(8);
  //maxRipple個数の波紋オブジェクトを生成する
  for (int i = 0; i < maxRipple; i++) {
    rp[i] = new Ripple();
  }
}

void draw() {
  background(0, 50, 75);

  //波紋クラスからオブジェクトをつくる
  for (int i = 0; i < maxRipple; i++) {
    rp[i].draw();
  }
}

//mousePressedを、mouseMovedにすると、マウスが動いたら波紋が出ます
void mousePressed() {
  //波紋オブジェクトを1個ずつ発生（マウス座標にセット）
  //　r_countを1ずつ増やし、maxRippleを超えたら0にする
  rp[r_count].set(mouseX, mouseY);
  r_count++;
  if (r_count>=maxRipple) {
    r_count=0;
  }
}



// -----------------------------------------------------------------
//波紋のクラス
class Ripple {

    int resolution = 32;    //波紋を描く、線分の数
    float rad = min(width / 2, height / 2);  //波紋の直径（画面の横幅/2か、高さ/2のうち、小さいほう）
    float x = 0;
    float y = 0;
    float t = 0; //時間
    float tChange = 0.05; //時間の増加量
    float nVal;
    float nInt = 0.2;
    float nAmp = 1;
    float ripple = 0;
    float mx = 0;
    float my = 0;
    float size = 0;
    float transparent = 0;

  //波紋のセット
  void set(float _mx, float _my) {
    size = 1;  //波紋のサイズ
    mx = _mx;  //波紋のX座標
    my = _my;  //波紋のY座標
    nInt = random(5, 10); // ノイズによるゆれ振幅
    nAmp = random(0.8, 1.0) ; //波紋のゆれの最小値（1.0に近いほうが円に近くなる）
  }

  //波紋の描画
  void draw() {

    size *= 0.97;  //徐々に0に近くなる計算（0.9だと速く、0.99だともっと遅く変化）

    push();
    translate(mx, my);    //波紋の原点を移動する

    //塗りと線の色
    noFill();
    transparent = size;              //sizeを透明度に使う
    stroke(255, 100 * transparent);  //線の色
    strokeWeight(10* transparent);  //線の幅

    //波紋の線分を描く
    beginShape();

    //線分を1周するまで、resolution本数に分けて、描く
    for (float a = 0; a <= TWO_PI; a += TWO_PI / resolution) {

      // ノイズ値でゆれの振幅を計算し、nAmp~1.0の範囲に整える
      nVal = map(noise(cos(a) * nInt + 1, sin(a) * nInt + 1, t), 0.0, 1.0, nAmp, 1.0);

      //線分を描く位置の計算
      x = cos(a) * rad * nVal * (1.0 - size);
      y = sin(a) * rad * nVal * (1.0 - size);

      //カーブ型の線分を描く
      curveVertex(x, y);

      //直線型の線分は以下のように
      //vertex(x, y);
    }
    endShape(CLOSE);  //線分を閉じる
    pop();

    //時間の変数を進める
    t += tChange;
  }
}
