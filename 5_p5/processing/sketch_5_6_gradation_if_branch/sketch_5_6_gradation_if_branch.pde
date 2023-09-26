//　---------- シリアル通信の部分 ここから ---------- //
//シリアル通信のライブラリを読込む
import processing.serial.*;

Serial myPort;  //シリアル通信を管理する変数
int PORT_NUM = 1;

//受信したセンサのデータを入れる配列
//受信データが3つなので、3コの配列をつくる
float[] sensorData=new float[3];

//データが送られてきたとき
void serialEvent (Serial p) {
  //文字列の改行まで読み取る
  String stringData=p.readStringUntil(10);

  if (stringData!=null) {
    //受け取った文字列にある先頭と末尾の空白を取り除き、データだけにする
    stringData=trim(stringData);

    //「,」で区切られたデータ部分を分離してbufferに格納する
    float buffer[] = float(split(stringData, ','));

    //bufferのデータが3個そろっていたら、sensorDataへ
    if (buffer.length>=3) {
      sensorData[0] = buffer[0];
      sensorData[1] = buffer[1];
      sensorData[2] = buffer[2];
    }
  }
}
//　---------- シリアル通信の部分 ここまで ---------- //

//空の色が変わるような感じで
//配列をつかった、パラメータ切替え

float averageX = 0;
float averageY = 0;
float averageZ = 0;


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
  //　---------- シリアル通信の部分 ここから ---------- //
  printArray(Serial.list());
  String portName = Serial.list()[PORT_NUM];
  myPort = new Serial(this, portName, 9600);
  //　---------- シリアル通信の部分 ここまで ---------- //
}

void draw() {
  //　---------- センサの値を整える ここから ---------- //
  // sensorData[0]~[2]をもとに、0〜100までの整数をつくる
  int x = int (map(sensorData[0], 1, -1, 0, 100));
  int y = int (map(sensorData[1], 1, -1, 0, 100));
  int z = int (map(sensorData[2], 1, -1, 0, 100));

  // constrainは、絶対に0〜100をはみ出さないようにする役割
  // 配列の数を超えないようにするため
  x = constrain(x, 0, 100);
  y = constrain(y, 0, 100);
  //　---------- センサの値を整える ここまで ---------- //

  //xの範囲で分ける 「以上」と「未満」がポイント
  if (x>=0 && x< 20) {
    count1 = 0;
  } else if (x>=20 && x<40) {
    count1 = 1;
  } else if (x>=40 && x<60) {
    count1 = 2;
  } else if (x>=60 && x<80) {
    count1 = 3;
  } else if (x>=80 && x<100) {
    count1 = 4;
  }

  //yの範囲で分ける 「以上」と「未満」がポイント
  if (y>=0 && y< 20) {
    count2 = 0;
  } else if (y>=20 && y<40) {
    count2 = 1;
  } else if (y>=40 && y<60) {
    count2 = 2;
  } else if (y>=60 && y<80) {
    count2 = 3;
  } else if (y>=80 && y<100) {
    count2 = 4;
  }

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
