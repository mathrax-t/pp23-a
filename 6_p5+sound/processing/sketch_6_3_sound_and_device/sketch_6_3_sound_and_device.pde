import processing.sound.*;

SoundFile[] file;

// 音のファイルの数
int numsounds = 5;
// 全部の音の数
int maxsounds = 10;

void setup() {
  size(640, 360);

  // 音のファイル数ぶんの、SoundFile配列をつくる
  file = new SoundFile[numsounds];

  // file配列に、サウンドファイルを読み込む
  file[0] = new SoundFile(this, "maou_se_inst_piano2_2re.wav");
  file[1] = new SoundFile(this, "maou_se_inst_piano2_3mi.wav");
  file[2] = new SoundFile(this, "maou_se_inst_piano2_5so.wav");
  file[3] = new SoundFile(this, "maou_se_inst_piano2_6ra.wav");
  file[4] = new SoundFile(this, "maou_se_inst_piano2_7si.wav");

  //　---------- シリアル通信の部分 ここから ---------- //
  printArray(Serial.list());
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  //　---------- シリアル通信の部分 ここまで ---------- //
}


// ひとつ前の瞬間のxを覚えておくための変数
int last_x = 0;
// 四角いエリアの透明度
float[] transparent = new float[maxsounds];

void draw() {
  background(0);

  // 四角いエリアを描く
  for (int i=0; i<maxsounds; i++) {
    // 透明度を徐々に変化させる
    transparent[i] *= 0.999;
    // 色を指定
    fill(i*(255/maxsounds), 0, 255, transparent[i]);
    // 四角を描く
    rect(i*(width/maxsounds), 0, (width/maxsounds), height);
  }
  
  //　---------- センサの値を整える ここから ---------- //
  // sensorData[0]をもとに、0〜maxsoundsまでの整数をつくる
  int x = int (map(sensorData[0], -1, 1, 0, maxsounds));
  //　---------- センサの値を整える ここまで ---------- //
  
  // constrainは、絶対に0〜maxsounds-1をはみ出さないようにする役割
  // 配列の番号を超えないようにするため
  x = constrain(x, 0, maxsounds-1);

  // 上の行で更新された今この瞬間のxが、last_x（=ひとつ前の瞬間のx）と違うとき、
  if (x != last_x) {

    if (x>=0 && x<numsounds) {
      // 音を鳴らす
      //file[x].stop();
      file[x].play(1, 0.25); // 1倍速
    } else if (x>=numsounds && x<numsounds*2) {
      // 音を鳴らす
      //file[x-numsounds].stop();
      file[x-numsounds].play(2, 0.25); // 2倍速
    }

    // 四角いエリアの透明度を255
    transparent[x] = 255;
  }
  // last_xに、この瞬間のxをおぼえておく（次のループで、ひとつ前の瞬間のxとなる）
  last_x = x;
}


//　---------- シリアル通信の部分 ここから ---------- //
import processing.serial.*;

Serial myPort;

float[] sensorData=new float[4];

//データが送られてきたとき
void serialEvent (Serial p) {
  //文字列の改行まで読み取る
  String stringData=p.readStringUntil(10);

  if (stringData!=null) {
    //受け取った文字列にある先頭と末尾の空白を取り除き、データだけにする
    stringData=trim(stringData);

    //「,」で区切られたデータ部分を分離してbufferに格納する
    float buffer[] = float(split(stringData, ','));

    //bufferのデータが4個そろっていたら、sensorDataへ
    if (buffer.length>=4) {
      sensorData[0] = buffer[0];
      sensorData[1] = buffer[1];
      sensorData[2] = buffer[2];
      sensorData[3] = buffer[3];
    }
  }
}
//　---------- シリアル通信の部分 ここまで ---------- //
