class City implements Target {
  PVector position;
  boolean isAlive;

  City(float x, float y) {
    position = new PVector(x, y);
    isAlive = true;
  }

  void display() {
    if (isAlive) {
      imageMode(CENTER);
      image(city, position.x, position.y, 76, 40);
      imageMode(CORNER);
    } else {
      imageMode(CENTER);
      image(destroyed_city, position.x, position.y, 76, 40);
      imageMode(CORNER);
    }

    if (debug) {
      fill(255, 0, 0);
      text("City", position.x, position.y);
      text("isAlive: " + isAlive, position.x, position.y + 10);
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
