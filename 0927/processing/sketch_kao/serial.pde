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
