//　---------- シリアル通信の部分 ここから ---------- //
//シリアル通信のライブラリを読込む
import processing.serial.*;

Serial myPort;    //シリアル通信を管理する変数
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

void init_serial() {
  printArray(Serial.list());  //シリアルポートの番号を確認
  String portName = Serial.list()[PORT_NUM];  //PORT_NUM番目のポートに接続（自分のPCでは1番目かどうか確認して適宜変更）
  myPort = new Serial(this, portName, 9600);  //選んだポートに9600の速度で接続する
}
//　---------- シリアル通信の部分 ここまで ---------- //


//最初だけ
void setup(){
  //画面のサイズ
  size(800,600);
  //fullScreen();
  init_serial();
}


//ずっと
void draw(){
  //画面の背景の色を塗る
  background(#cdb4db);
  
  draw_kao1();
}


//　---------- かおの絵 ここから ---------- //
float x1, y1, z1;
float t1;

void draw_kao1() {
  int new_x =int( map(sensorData[0], -1, 1, -150, 150));
  int new_y =int( map(sensorData[1], -1, 1, -100, 100));
  int new_z =int( map(sensorData[2], -1, 1, -40, 40));
  
  x1 = x1*(3.0/4.0) + new_x*(1.0/4.0);
  y1 = y1*(3.0/4.0) + new_y*(1.0/4.0);
  z1 = z1*(3.0/4.0) + new_z*(1.0/4.0);
  
  t1 += 0.025;

  noStroke();
  fill(#ffc8dd);
  ellipse(width/2, height/2, 400+z1, 400+z1);

  fill(#264653);
  ellipse(width/2-50+x1, height/2-100+y1, 10, 20);

  fill(#264653);
  ellipse(width/2+50+x1, height/2-100+y1, 10, 20);

  fill(#fb6f92);
  ellipse(width/2+x1, height/2+y1, x1*1+20, y1+20);

  fill(#ffffff);
  ellipse(width/2 + sin(t1)*250, height/2 + cos(t1)*250, 40+z1, 40+z1);
}
//　---------- かおの絵 ここまで ---------- //
