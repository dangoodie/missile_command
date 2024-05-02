class City {
  PVector location;
  boolean isAlive;

  City(float x, float y) {
    location = new PVector(x, y);
    isAlive = true;
  }

  void display() {
    fill(255);
    stroke(0);
    ellipse(location.x, location.y, 8, 8);
  }

  void destroy() {
    isAlive = false;
  }
}