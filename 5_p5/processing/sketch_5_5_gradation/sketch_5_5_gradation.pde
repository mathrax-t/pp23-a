//空の色が変わるような感じで
//配列をつかった、パラメータ切替え

//配列の何番目か決める変数
int count1 = 0;
int count2 = 0;

//配列で色を用意しておく
//カラーパレット生成のサイト使うと便利
//https://coolors.co/
int[] col1 = {#000000, #ffbe0b, #fb5607, #ff006e, #8338ec};
int[] col2 = {#9b5de5, #f15bb5, #fee440, #00bbf9, #00f5d4};

//透明度につかう変数
float transparent = 0;


void setup() {
  size(800, 600);
  //fullScreen();
}

void draw() {
  
  //透明度につかう変数を、
  //常に1.0になるまで、0.01ずつ増やす
  transparent += 0.01;
  if (transparent>1.0)transparent=1.0;

  //2つの色で少しずつ色を変えながら、
  //細い四角をずらして描くと、
  //グラデーションする四角になる
  color c1 = color(col1[count1]);
  color c2 = color(col2[count2]);
  
  for (float h = 0; h < height; h += 5) {
    color c = lerpColor(c1, c2, h / height);
    noStroke();
    //塗りつぶす色と透明度
    fill(c, transparent*255);
    rect(0, h, width, 5);
  }
  
}

//キーを押したとき
void keyPressed() {
  
  //透明度を0にする
  transparent = 0;

  //q,w,e,r,tを押したとき
  //count1を0,1,2,3,4にする
  if (key == 'q') {
    count1 = 0;
  }
  if (key == 'w') {
    count1 = 1;
  }
  if (key == 'e') {
    count1 = 2;
  }
  if (key == 'r') {
    count1 = 3;
  }
  if (key == 't') {
    count1 = 4;
  }
  // ----------

  //a,s,d,f,gを押したとき
  //count2を0,1,2,3,4にする
  if (key == 'a') {
    count2 = 0;
  }
  if (key == 's') {
    count2 = 1;
  }
  if (key == 'd') {
    count2 = 2;
  }
  if (key == 'f') {
    count2 = 3;
  }
  if (key == 'g') {
    count2 = 4;
  }
  // ----------
}
