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

import processing.sound.*;

SoundFile[] file;

//音のファイルの数
//「コマンド＋K」で、サウンドファイルの保存場所がでます
int numsounds = 15;

void setup() {
  size(800, 600);

  // 音のファイル数ぶんの、SoundFile配列をつくる
  file = new SoundFile[numsounds];

  // file配列に、サウンドファイルを読み込む
  for (int i=0; i<numsounds; i++) {
    file[i] = new SoundFile(this, nf(i+1, 2)+".wav"); //nfで「01」など0で埋めて桁合わせできる
  }
  //file[1] = new SoundFile(this, "02.wav");
  //file[2] = new SoundFile(this, "03.wav");

  //　---------- シリアル通信の部分 ここから ---------- //
  printArray(Serial.list());
  String portName = Serial.list()[PORT_NUM];
  myPort = new Serial(this, portName, 9600);
  //　---------- シリアル通信の部分 ここまで ---------- //
}


// 四角いエリアの透明度
float[] transparent_x = new float[numsounds];
float[] transparent_y = new float[numsounds];

void draw() {
  background(0);

  // 四角いエリアを描く
  for (int i=0; i<numsounds; i++) {
    // 透明度を徐々に変化させる
    transparent_x[i] *= 0.99;
    transparent_y[i] *= 0.99;
    //線なし
    noStroke();
    color c1 = lerpColor(color(#ff006e), color(#ffbe0b), float(i)/float(numsounds));
    // 色を指定
    fill(c1, 255*transparent_x[i]);
    // 四角を描く
    rect(i*(width/float(numsounds)), 0, (width/float(numsounds)), height);
    // 色を指定
    color c2 = lerpColor(color(#3a86ff), color(#ff006e), float(i)/float(numsounds));
    fill(c2, 255*transparent_y[i]);
    // 四角を描く
    rect(0, i*(height/float(numsounds)), width, (height/float(numsounds)));
  }

  //　---------- センサの値を整える ここから ---------- //
  // sensorData[0]をもとに、0〜numsoundsまでの整数をつくる
  int x = int (map(sensorData[0], 1, -1, 0, numsounds));
  int y = int (map(sensorData[1], 1, -1, 0, numsounds));
  //int x = int (map(mouseX, 0, width, 0, numsounds));
  //int y = int (map(mouseY, 0, height, 0, numsounds));
  //　---------- センサの値を整える ここまで ---------- //

  // constrainは、絶対に0〜numsounds-1をはみ出さないようにする役割
  // 配列の数を超えないようにするため
  x = constrain(x, 0, numsounds-1);
  y = constrain(y, 0, numsounds-1);


  //if (sensorData[2]>0) {  //Z軸のセンサで、音を鳴らす・鳴らさない
  //15フレームおきに
  if (frameCount%15==0) {
    file[x].stop();
    file[x].play(1, 0.125);
    file[y].stop();
    file[y].play(1, 0.125);
    // 四角いエリアの透明度を1.0
    transparent_x[x] = 1.0;
    transparent_y[y] = 1.0;
  }
}
