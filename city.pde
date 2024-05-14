class City implements Target {
  PVector position;
  boolean isAlive;

  City(float x, float y) {
    position = new PVector(x, y);
    isAlive = true;
  }

  void display() {
    if (isAlive) {
      fill(255);
      stroke(0);
      imageMode(CENTER);
      image(city, position.x, position.y, 76, 40);
      imageMode(CORNER);
      
      if (debug) {
        fill(255, 0, 0);
        text("City", position.x, position.y);
      }
    } else {
      // Display destroyed city
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
