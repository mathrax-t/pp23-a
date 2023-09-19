/**
 * Storing Input.
 *
 * Move the mouse across the screen to change the position
 * of the circles. The positions of the mouse are recorded
 * into an array and played back every frame. Between each
 * frame, the newest value are added to the end of each array
 * and the oldest value is deleted.
 */

int num = 60;
float mx[] = new float[num];
float my[] = new float[num];

void setup() {
  size(640, 360);
  noStroke();
  fill(255, 153);
  
  //　---------- シリアル通信の部分 ここから ---------- //
  printArray(Serial.list());
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  //　---------- シリアル通信の部分 ここまで ---------- //

}

void draw() {
  background(51);

  //　---------- センサの値を整える ここから ---------- //
  float x = map(sensorData[0], -1, 1, 0, width);
  float y = map(sensorData[1], -1, 1, 0, height);
  float z = map(sensorData[2], -1, 1, 0, 100);
  //　---------- センサの値を整える ここまで ---------- //


  // Cycle through the array, using a different entry on each frame.
  // Using modulo (%) like this is faster than moving all the values over.
  int which = frameCount % num;
  //　---------- 整えた値をつかう ここから ---------- //
  mx[which] = x;  // mouseXをxに
  my[which] = y;  // mouseYをyに
  //　---------- 整えた値をつかう  ここまで ---------- //

  for (int i = 0; i < num; i++) {
    // which+1 is the smallest (the oldest in the array)
    int index = (which+1 + i) % num;
    ellipse(mx[index], my[index], i, i);
  }
}

//　---------- シリアル通信の部分 ここから ---------- //
import processing.serial.*;

Serial myPort;

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
