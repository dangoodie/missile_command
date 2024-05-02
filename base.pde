class Base {
  PVector position; // Position of the base
  boolean isActive; // State of the base

  Base(float x, float y) {
    position = new PVector(x, y);
    isActive = true;
  }

  void display() {
    fill(0, 255, 0);
    noStroke();
    ellipse(position.x, position.y, 20, 20); // Drawing the base
  }

  void destroy() {
    isActive = false;
  }
}