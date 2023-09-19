import processing.serial.*;

Serial myPort;

float[] sensorData=new float[3];

void setup() {
  size(800, 600);
  noStroke();

  printArray(Serial.list());
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  background(200);

  //fill(200,10);
  //noStroke();
  // rect(0,0,width,height);

  float x = map(sensorData[0], -1, 1, 0, width);
  float y = map(sensorData[1], -1, 1, 0, height);
  float z = map(sensorData[2], -1, 1, 0, 100);

  fill(255);
  stroke(0);
  circle(x, y, z);
}



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
