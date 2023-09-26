//最初だけ
void setup(){
  //画面のサイズ
  size(800,600);
  //fullScreen();
  init_serial();
}


//ずっと
void draw(){
  //画面の背景の色を塗る
  background(#cdb4db);
  
  draw_kao1();
}
