/**
 * Brightness 
 * by Rusty Robison. 
 * 
 * Brightness is the relative lightness or darkness of a color.
 * Move the cursor vertically over each bar to alter its brightness. 
 */
 
int barWidth = 20;
int lastBar = -1;

void sample2_setup() {
  //size(640, 360);
  colorMode(HSB, width, 100, height);
  noStroke();
  background(0);
}

void sample2_draw() {
  int whichBar = mouseX / barWidth;
  if (whichBar != lastBar) {
    int barX = whichBar * barWidth;
    fill(barX, 100, mouseY);
    rect(barX, 0, barWidth, height);
    lastBar = whichBar;
  }
}
