//ステートマシン

int scene = 0;

void setup() {
  size(800, 600);
}


void draw() {
  switch(scene) {
  case 0:
    background(0, 0, 0);
    break;

  case 1:
    background(255, 0, 0);
    break;

  case 2:
    background(0, 255, 0);
    break;

  case 3:
    background(0, 0, 255);
    break;

  case 4:
    background(255, 0, 255);
    break;
  }
}

void mousePressed() {
  scene ++;
  if (scene>=5) {
    scene = 0;
  }
}
