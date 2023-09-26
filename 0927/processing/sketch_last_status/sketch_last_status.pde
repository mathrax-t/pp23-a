int status = 0;        //状態を覚えておく変数
int last_status = 0;   //直前の状態を覚えておく変数

void setup() {
  size(800, 600);
}

void draw() {
  //今この瞬間の状態（status）
  //マウスXを0~100に整える
  status = int(map(mouseX, 0, width, 0, 100));

  //今この瞬間の状態(status)と、直前の状態（last_status)が異なる時
  if (status != last_status) {
    //背景色をランダムに変える
    background(random(255),random(255),random(255));
  }
  
  //直前の状態として、今この瞬間の状態を覚えておく
  last_status = status;
}
