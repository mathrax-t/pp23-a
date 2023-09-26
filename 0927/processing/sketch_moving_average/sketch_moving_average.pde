//移動平均

float averageX = 0;  //平均値 X
float averageY = 0;  //平均値 Y

float myX = 0;       //円のX座標
float myY = 0;       //円のY座標

void setup(){
  size(800,600);
}

void draw(){
  background(0);

  noStroke();
  fill(255,0,255);
  circle(mouseX, mouseY, 100);
  
  //10回の移動平均
  averageX = (averageX*(9.0/10.0)) + (mouseX / 10.0);
  averageY = (averageY*(9.0/10.0)) + (mouseY / 10.0);
  
  //円の座標を、平均値にする
  myX = averageX;
  myY = averageY;
  
  noStroke();
  fill(0,255,255);
  circle(myX, myY, 100);
  
}
