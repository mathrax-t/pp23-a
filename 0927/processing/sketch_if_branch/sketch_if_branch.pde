void setup() {
  size(800, 600);
}

void draw() {
  float x = map(mouseX, 0, width, 0, 100);
  
  //xの範囲で分ける 「以上」と「未満」がポイント
  if (x>=0 && x< 20) {
    background(0, 10, 60);
    
  } else if (x>=20 && x<40) {
    background(10, 20, 70);
    
  } else if (x>=40 && x<60) {
    background(20, 30, 80);
    
  } else if (x>=60 && x<80) {
    background(30, 40, 90);
    
  } else if (x>=80 && x<100) {
    background(40, 50, 100);
    
  }
}
