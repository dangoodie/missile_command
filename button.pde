class Button {
  float x, y; // Position
  float w, h; // Width and height
  String label; // Button text
  Runnable action; // Action to perform on click
  
  // Default values that can be changed
  color bgColor = 200;
  color bgHoverColor = 160;
  color textColor = 0;
  int textSize = 20;

  Button(float x, float y, float w, float h, String label, Runnable action) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.action = action;
  }

  void display() {
    pg.beginDraw();
    if (this.overButton()) {
      pg.fill(bgHoverColor);
    } else {
      pg.fill(bgColor);  
    }

    // Draw button with rounded corners
    pg.noStroke();
    pg.smooth();
    pg.rect(x, y, w, h, 10);
    pg.fill(textColor);

    pg.textSize(textSize);
    pg.textAlign(CENTER, CENTER);
    pg.text(label, x + w/2, y + h/2);
    pg.endDraw();
  }

  boolean overButton() {
    // Check if the mouse is over the button
    return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
  }

  void checkClick() {
    if (overButton() && mousePressed) {
      action.run();
      mousePressed = false;
    }
  }
}
