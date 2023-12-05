PImage img1;
PImage img2;
float t;

float x;
float y;
float easing = 0.05;


void setup(){
  size(800,600);
  //fullScreen();
  img1 = loadImage("bg.jpg");
  img2 = loadImage("mask.png");
  imageMode(CENTER);
}

void draw(){
  blendMode(BLEND);
  background(0);
  
  t = t + 0.03;
  
  
  float targetX = mouseX;
  float dx = targetX - x;
  x += dx * easing;
  
  float targetY = mouseY;
  float dy = targetY - y;
  y += dy * easing;
  
  blendMode(BLEND);
  image(img2, x,y, 300+50*sin(t), 300+50*sin(t));
  
  blendMode(DARKEST);
  image(img1, width/2,height/2);
}
