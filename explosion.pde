class Explosion {
  PVector position;
  float lifespan = 50;
  float size = 0;

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

  // Getter methods
  public float getX() {
    return position.x;
  }

  public float getY() {
    return position.y;
  }
}
