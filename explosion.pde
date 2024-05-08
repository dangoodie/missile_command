class Explosion {
  PVector position;
  float size = 0;
  float lifespan = 50;

  Explosion(float x, float y) {
    position = new PVector(x, y);
  }

  void update() {
    lifespan -= 1;
    size += 2; // Increase the size of the explosion
  }

  void display() {
    noStroke();
    fill(255, 150, 0, lifespan * 5); // Color fades as the explosion "ages"
    ellipse(position.x, position.y, size, size);
  }

  boolean isDead() {
    return lifespan < 0;
  }

  boolean detectCollisionWithinRadius(float targetX, float targetY) {
    float distance = dist(position.x, position.y, targetX, targetY);
    return distance <= size;
  }

  // Getter methods
  public float getX() {
    return position.x;
  }

  public float getY() {
    return position.y;
  }
}
