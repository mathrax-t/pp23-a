//ステートマシン
int scene = 0; //シーンの番号

void setup() {
  size(800, 600);
}


void draw() {
  //scene変数によって場合分けする
  //ifでも書けるけど場合分けが増えると、
  //switch caseを使うと見やすい
  switch(scene) {
  case 0:
    background(#283618);
    //noStroke();
    //fill(#dda15e);
    //ellipse(width/2, height/2, 200, 200);
    break;

  case 1:
    background(#606c38);
    //noStroke();
    //fill(#dda15e);
    //rect(width/2, height/2, 100, 100);
    //fill(#fefae0);
    //rect(width/2-100, height/2-100, 100, 100);
    break;

  case 2:
    background(#264653);
    //noStroke();
    //fill(#2a9d8f);
    //ellipse(width/2, 0, 1600, 400);
    //fill(#e76f51);
    //ellipse(width/2, height, 1600, 400);
    //fill(#e9c46a);
    //rect(width/2, height/2-200, 200, 200);
    //fill(#f4a261);
    //rect(width/2-200, height/2, 200, 200);
    break;

  case 3:
    background(#e5e5e5);
    //noStroke();
    //fill(#14213d);
    //ellipse(width/2, 0, 1600, 400);
    //fill(#000000);
    //ellipse(width/2, height, 1600, 400);
    //fill(#fca311);
    //rect(width/2-200, height/2-200, 200, 200);
    //fill(#ffffff);
    //rect(width/2, height/2, 200, 200);
    break;

  case 4:
    background(#1d3557);
    //noStroke();
    //fill(#a8dadc);
    //rect(0,height/3,width,height/3);
    //fill(#f1faee);
    //ellipse(width/4, height/2, 40, 40);
    //fill(#e63946);
    //ellipse(width/4*2, height/2, 40, 40);
    //fill(#f1faee);
    //ellipse(width/4*3, height/2, 40, 40);
    break;
  }
}

void mousePressed() {
  scene ++;
  if (scene>=5) {
    scene = 0;
  }
}
