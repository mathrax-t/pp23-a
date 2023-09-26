//ふつうの平均

float averageX = 0;  //平均値 X
float averageY = 0;  //平均値 Y

float myX = 0;       //円のX座標
float myY = 0;       //円のY座標

void setup() {
  size(800, 600);
}

void draw() {
  background(0);

  noStroke();
  fill(255, 0, 255);
  circle(mouseX, mouseY, 100);

  //10フレームおきに
  if (frameCount % 10 == 0) {
    averageX /= 10;                //平均値Xを、10で割る
    averageY /= 10;                //平均値Yを、10で割る
    myX = averageX;                //円のX座標を、平均値Xにする
    myY = averageY;                //円のY座標を、平均値Yにする
  } else {
    averageX = averageX + mouseX;  //平均値Xに、mouseXを足す
    averageY = averageY + mouseY;  //平均値Yに、mouseYを足す
  }
  
  //平均値の座標に円を描く
  noStroke();
  fill(0, 255, 255);
  circle(myX, myY, 100);
}
