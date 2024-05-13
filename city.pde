class City implements Target {
  PVector position;
  boolean isAlive;

  City(float x, float y) {
    position = new PVector(x, y);
    isAlive = true;
  }

  void display() {
    if (isAlive) {
      pg.beginDraw();
      pg.fill(255);
      pg.stroke(0);
      pg.ellipse(position.x, position.y, 8, 8);
      pg.endDraw();
    } else {
      // display destroyed city
    }
  }

  void destroy() {
    isAlive = false;
  }

  PVector getPosition() {
    return position;
  }

  boolean isAlive() {
    return isAlive;
  }
}
