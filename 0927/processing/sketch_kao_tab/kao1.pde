float x1, y1, z1;
float t1;

void draw_kao1() {
  int new_x =int( map(sensorData[0], -1, 1, -150, 150) );
  int new_y =int( map(sensorData[1], -1, 1, -100, 100) );
  int new_z =int( map(sensorData[2], -1, 1, -40, 40) );
  
  x1 = x1*(3.0/4.0) + new_x*(1.0/4.0);
  y1 = y1*(3.0/4.0) + new_y*(1.0/4.0);
  z1 = z1*(3.0/4.0) + new_z*(1.0/4.0);
  
  t1 += 0.025;

  noStroke();
  fill(#ffc8dd);
  ellipse(width/2, height/2, 400+z1, 400+z1);

  fill(#264653);
  ellipse(width/2-50+x1, height/2-100+y1, 10, 20);

  fill(#264653);
  ellipse(width/2+50+x1, height/2-100+y1, 10, 20);

  fill(#fb6f92);
  ellipse(width/2+x1, height/2+y1, x1*1+20, y1+20);

  fill(#ffffff);
  ellipse(width/2 + sin(t1)*250, height/2 + cos(t1)*250, 40+z1, 40+z1);
}
