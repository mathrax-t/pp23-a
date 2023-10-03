//　----------ESPNow通信： シリアル通信の部分 ここから ---------- //
//シリアル通信のライブラリを読込む
import processing.serial.*;

Serial myPort;  //シリアル通信を管理する変数

//シリアルポートの番号
int PORT_NUM = 1;

//リーダーの台数
int LEADER_NUM = 2;

//受信したセンサのデータを入れる配列
//受信データ最大個数が[3*LEADER_NUM]なので、その分の配列をつくる
float[] sensorData=new float[3*LEADER_NUM];

//データが送られてきたとき
void serialEvent (Serial p) {
  //文字列の改行まで読み取る
  String stringData=p.readStringUntil(10);

  if (stringData!=null) {
    //受け取った文字列にある先頭と末尾の空白を取り除き、データだけにする
    stringData=trim(stringData);

    //「,」で区切られたデータ部分を分離してbufferに格納する
    float buffer[] = float(split(stringData, ','));

    //bufferのデータが[3*LEADER_NUM]個そろっていたら、sensorDataへ
    if (buffer.length>=3*LEADER_NUM) {
      for (int i=0; i<3*LEADER_NUM; i++) {
        sensorData[i] = buffer[i];
      }
    }
  }
}
//　----------　ESPNow通信：シリアル通信の部分 ここまで ---------- //


float[] x = new float[LEADER_NUM];
float[] y= new float[LEADER_NUM];
float[] z= new float[LEADER_NUM];


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
  background(#7C8893);

  leader(0, #E33121);  //リーダー番号0、色情報
  leader(1, #D7864B); //リーダー番号1、色情報
}


void leader(int num, int col) {
  //　---------- センサの値を整える ここから ---------- //
  // sensorData[0]~[12]をもとに、0〜100までの整数をつくる
  int new_x = int (map(sensorData[num*3+0], 1, -1, 0, width));
  int new_y = int (map(sensorData[num*3+1], 1, -1, 0, height));
  int new_z = int (map(sensorData[num*3+2], 1, -1, 0, 100));

  // constrainは、絶対に範囲をはみ出さないようにする役割
  // 配列の数を超えないようにするため
  new_x = constrain(new_x, 0, width);
  new_y = constrain(new_y, 0, height);
  new_z = constrain(new_z, 0, 100);

  //10回の移動平均
  x[num] = x[num] *(9.0/10.0) + float(new_x)/10.0;
  y[num] = y[num] *(9.0/10.0) + float(new_y)/10.0;
  z[num] = z[num] *(9.0/10.0) + float(new_z)/10.0;
  //　---------- センサの値を整える ここまで ---------- //

  //リーダーの加速度XYZをつかって、まるを描く
  noStroke();
  fill(col);
  ellipse(x[num], y[num], z[num] +20, z[num] +20);
}
