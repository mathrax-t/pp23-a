/**
 * Hue. 
 * 
 * Hue is the color reflected from or transmitted through an object 
 * and is typically referred to as the name of the color such as 
 * red, blue, or yellow. In this example, move the cursor vertically 
 * over each bar to alter its hue. 
 */
 
int barWidth = 20;
int lastBar = -1;

void setup() {
  size(640, 360);
  colorMode(HSB, height, height, height);  
  noStroke();
  background(0);
  
  //　---------- シリアル通信の部分 ここから ---------- //
  printArray(Serial.list());
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  //　---------- シリアル通信の部分 ここまで ---------- //
}

void draw() {
    //　---------- センサの値を整える ここから ---------- //
  float x = map(sensorData[0], -1, 1, 0, width);
  float y = map(sensorData[1], -1, 1, 0, height);
  float z = map(sensorData[2], -1, 1, 0, 100);
  //　---------- センサの値を整える ここまで ---------- //
  
  int whichBar =int( x / barWidth);  // mouseXをxに
  if (whichBar != lastBar) {
    int barX = whichBar * barWidth;
    fill(y, height, height);    // mouseYをyに
    rect(barX, 0, barWidth, height);
    lastBar = whichBar;
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
