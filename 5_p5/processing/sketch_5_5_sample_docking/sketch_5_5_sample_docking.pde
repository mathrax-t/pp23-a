//2つのサンプルを切り替える

int scene = 0;  //シーン番号の変数
int first = 0;    //最初に1回だけ実行したいときの変数

//メイン画面のセットアップ
void setup() {
  size(800, 600);
}

//メイン画面の描画
void draw() {
  //もしfirstが0だったら、
  if (first==0) {
    //firstを1にする
    first = 1;
    //シーン番号ごとに、各シーンのsetupを呼出す
    switch(scene) {
    case 0:
      sample1_setup();
      break;
    case 1:
      sample2_setup();
      break;
    }
  }

  //シーン番号ごとに、各シーンのdrawを呼び出す
  switch(scene) {
  case 0:
    sample1_draw();
    break;
  case 1:
    sample2_draw();
    break;
  }
}

//キー入力
void keyPressed(){
  //firstを0にリセット
  first = 0;
  
  //「1」を押したら、シーン番号を0に
  if(key=='1'){
    scene = 0;
  }
  //「2」を押したら、シーン番号を1に
  if(key=='2'){
    scene = 1;
  }
}
