void setup() {
  size(800, 600);
  //frameRate(60); //特に指定しないと60fps
}

void draw() {
  if (frameCount % 30 == 0) {
    background(random(255), random(255), random(255));
  }
}
