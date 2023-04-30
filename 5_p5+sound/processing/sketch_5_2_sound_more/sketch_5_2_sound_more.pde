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

  // mouseXをもとに、0〜maxsoundsまでの整数をつくる
  int x = int (map(mouseX, 0, width, 0, maxsounds));
  // constraintは、絶対に0〜maxsounds-1をはみ出さないようにする役割
  // 配列の番号を超えないようにするため
  x = constrain(x, 0, maxsounds-1);

  // 上の行で更新された今この瞬間のxが、last_x（=ひとつ前の瞬間のx）と違うとき、
  if (x != last_x) {

    if (x>=0 && x<numsounds) {
      // 音を鳴らす
      file[x].play(1, 0.25); // 1倍速
    } else if (x>=numsounds && x<numsounds*2) {
      // 音を鳴らす
      file[x-numsounds].play(2, 0.25); // 2倍速
    }

    // 四角いエリアの透明度を255
    transparent[x] = 255;
  }
  // last_xに、この瞬間のxをおぼえておく（次のループで、ひとつ前の瞬間のxとなる）
  last_x = x;
}
