// 分割数
int splitNum = 5;
// 全部の音の数
int splitMax = 10;

/* ArrayListについて
 http://www.isc.meiji.ac.jp/~kikn/PDE/PDE9-Listsb.pdf
 https://teratail.com/questions/36328
 */
/* PVectorについて
 https://dekfractal.com/1371.html
 */
/* 2次元配列について
 https://cocopon.me/zero-pde/array-2d/
 */
ArrayList<ArrayList<PVector>> lines = new ArrayList<ArrayList<PVector>>();
ArrayList<PVector> lineSpeeds = new ArrayList<PVector>();
ArrayList<Float> alphas = new ArrayList<Float>();


void setup () {

  // https://processing.org/reference/frameRate_.html
  frameRate(60);

  // https://qiita.com/takelushi/items/5bcc4d6ea1c8f34e5cd6
  size(360, 640);
  //fullScreen();

  println( "content size:", width, height );

  background(0);


  //　---------- シリアル通信の部分 ここから ---------- //
  // https://processing.org/reference/libraries/serial/index.html
  printArray(Serial.list());
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  //　---------- シリアル通信の部分 ここまで ---------- //
}


// ひとつ前の瞬間のxを覚えておくための変数
int last_x = 0;

void draw () {

  background(0);

  if ( lines.size() < 80 && random(1.0) < 0.5 ) AddLine();
  DrawLines();


  //　---------- センサの値を整える ここから ---------- //

  // sensorData[0]をもとに、0〜splitMaxまでの整数をつくる
  int x = int (map(sensorData[0], -1, 1, splitMax, 0));
  //println(x);

  //　---------- センサの値を整える ここまで ---------- //



  // constrainは、絶対に0〜splitMax-1をはみ出さないようにする役割
  // 配列の番号を超えないようにするため
  x = constrain(x, 0, splitMax-1);

  // 上の行で更新された今この瞬間のxが、last_x（=ひとつ前の瞬間のx）と違うとき、
  if (x != last_x) {

    if (x>=0 && x<splitNum) {
    } else if (x>=splitNum && x<splitNum*2) {
    }
  }

  // last_xに、この瞬間のxをおぼえておく（次のループで、ひとつ前の瞬間のxとなる）
  last_x = x;
}

/* Time
 https://gotutiyan.hatenablog.com/entry/2020/08/07/201615#%E6%99%82%E9%96%93%E3%82%92%E6%89%B1%E3%81%86%E3%81%9F%E3%82%81%E3%81%AE%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E5%A4%89%E6%95%B0
 */
void AddLine () {

  PVector lineSpeed = new PVector( random(1, 4), 0 );
  lineSpeeds.add( lineSpeed );

  Float alpha = random( 50, 255 );
  alphas.add( alpha );


  ArrayList newLine = new ArrayList<PVector>();

  for ( int pointPosX = 0; pointPosX <= width; pointPosX+=2 ) {

    //newLine.add( new PVector(pointPosX, 0 + cos( ( ( pointPosX + second() ) * 0.005 ) * millis() ) * 10 ) );
    newLine.add( new PVector(pointPosX, 0 + cos( (pointPosX + millis()) * 0.01 * lineSpeed.x ) * 10 ) );
  }

  lines.add( newLine );

  //println( "Add newLine" );
}

void DrawLines () {


  for ( int lineNumber = 0; lineNumber < lines.size(); lineNumber++ ) {

    PVector lineSpeed = lineSpeeds.get(lineNumber);
    lineSpeed.y += lineSpeed.x;
    lineSpeeds.set( lineNumber, lineSpeed );

    // https://processing.org/reference/stroke_.html
    stroke(255, alphas.get(lineNumber));

    ArrayList<PVector> currentLine = lines.get(lineNumber);
    for ( int pointNumber = 0; pointNumber < currentLine.size(); pointNumber++ ) {

      PVector updatePoint = PVector.add( currentLine.get(pointNumber), new PVector( 0, lineSpeed.x ) );

      currentLine.set(pointNumber, updatePoint);

      if ( pointNumber > 0 ) {

        line( currentLine.get(pointNumber-1).x, currentLine.get(pointNumber-1).y,
          currentLine.get(pointNumber).x, currentLine.get(pointNumber).y );
      }
    }

    if ( lineSpeed.y > height * 1.1 ) {

      lines.remove( lineNumber );
      lineSpeeds.remove( lineNumber );
      alphas.remove( lineNumber );
    }
  }

  if ( lineSpeeds.size() > 0 )
    println( lineSpeeds.get(0) );
}

/* keyboard
 http://www.musashinodenpa.com/p5/index.php?pos=1439
 
 Pause
 https://stackoverflow.com/questions/45202108/how-to-pause-play-a-sketch-in-processing-with-the-same-button
 */

boolean paused = false;

void keyPressed () {

  if (key == CODED) {

    if (keyCode == ESC) {
      exit();
    }
  }

  if (keyCode == ' ') {
    paused = !paused;

    if (paused) {
      noLoop();
    } else {
      loop();
    }
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
  //println(stringData);


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
