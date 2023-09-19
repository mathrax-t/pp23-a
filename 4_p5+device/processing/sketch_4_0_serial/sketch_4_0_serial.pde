//　---------- シリアル通信の部分 ここから ---------- //
//シリアル通信のライブラリを読込む
import processing.serial.*;

Serial myPort;  // シリアル通信を管理する変数

//受信したセンサのデータを入れる配列
//受信データが3つなので、3コの配列をつくる
float[] sensorData=new float[3];

//シリアル通信でデータを受けとると自動的に呼び出される
void serialEvent (Serial p) {

  //文字列の改行まで読み取る（ASCIIコードの「10」が改行を示す）
  String stringData = p.readStringUntil(10);

  if (stringData!=null) {  //stringDataが空っぽでなければ
    //文字列にある先頭と末尾の空白を取り除き、データだけに整える
    stringData=trim(stringData);

    //「,」で区切られたデータ部分を分けて、buffer配列に格納する
    float buffer[] = float(split(stringData, ','));

    //buffer配列のデータが3個そろったら、sensorDataへ入れる
    if (buffer.length>=3) {
      sensorData[0] = buffer[0];
      sensorData[1] = buffer[1];
      sensorData[2] = buffer[2];
    }
  }
}
//　---------- シリアル通信の部分 ここまで ---------- //


//最初だけ
void setup() {
  size(640, 480);

  //　---------- シリアル通信の部分 ここから ---------- //
  printArray(Serial.list());  //シリアルポートの番号を確認
  String portName = Serial.list()[1];  //1番目のポートに接続（自分のPCでは1番目かどうか確認して適宜変更）
  myPort = new Serial(this, portName, 9600);  //選んだポートに、9600の速度で接続する
  //　---------- シリアル通信の部分 ここまで ---------- //
}

//ずっと
void draw() {
  //-1.0~1.0まで変化する、sensorDataを何につかうか、あなた次第！
  background(sensorData[0]*255, sensorData[1]*255, sensorData[2]*255);

  textSize(24);                //文字のサイズ
  textAlign(LEFT, CENTER);   //文字の整列（ヨコ中央、タテ中央）
  text("x : "+ sensorData[0], 120, height/2);
  text("y : "+ sensorData[1], 280, height/2);
  text("z : "+ sensorData[2], 440, height/2);
}
