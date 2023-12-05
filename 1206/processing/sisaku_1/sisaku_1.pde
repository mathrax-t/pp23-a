
rDraw[] d = new rDraw[2];

void setup() {
  size(800, 600);
  d[0] = new rDraw(100, 300);
  d[1] = new rDraw(700, 300);
  background(255);
}


void draw() {
  noStroke();
  fill(255, 5);
  rect(0, 0, width, height);
  for (int i=0; i<2; i++) {
    d[i].draw();
  }
}




class rDraw {
  int x_flag = 0;
  int y_flag = 0;
  float angle =0;

  float center_x;
  float center_y;

  float dst = 0;
  float x;
  float y;
  float easing = 0.05;

  rDraw(float _x, float _y) {
    center_x = _x;
    center_y = _y;
  }

  void draw() {

    push();

    float targetX = mouseX;
    float dx = targetX - x;
    x += dx * easing;

    float targetY = mouseY;
    float dy = targetY - y;
    y += dy * easing;
    translate(x, y);

    //atan2は角度を求める関数です。x,yとの角度を求めています
    angle = atan2(mouseY-center_y, mouseX-center_x);
    rotate(angle);
    
    dst = dist(x, y, center_x, center_y);

    float transparent = constrain(map(dst, 200, 0, 0.0, 1.0),0.0,1.0);
    
    fill(0, 255*transparent);
    circle(-40, 0, 5);
    circle(-20, 0, 5);
    circle(0, 0, 5);
    circle(20, 0, 5);
    circle(40, 0, 5);
    pop();
  }
}
