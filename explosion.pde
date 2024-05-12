class Explosion {
  PVector position;
  float size = 0;
  float lifespan;
  boolean isEnemy;

  Explosion(float x, float y, boolean isEnemy) {
    position = new PVector(x, y);
    this.isEnemy = isEnemy;
    if (isEnemy) {
      lifespan = 30;
    } else {
      lifespan = 50;
    }
  }

  void update() {
    lifespan -= 1;
    size += 2; // Increase the size of the explosion
  }

  void display() {
    // noStroke();
    fill(255, 150, 0, lifespan * 5); // Color fades as the explosion "ages"
    ellipse(position.x, position.y, size, size);

    // Uncomment if there are different images for enemies and anti-missiles
    // if (isEnemy) {
    //   image(enemy_explosion, position.x - size/2, position.y - size/2, size, size);
    // } else {
    //   image(antimissile_explosion, position.x - size/2, position.y - size/2, size, size);
    // }
  }

  boolean isDead() {
    return lifespan < 0;
  }

  boolean detectCollisionWithinRadius(float targetX, float targetY) {
    float distance = dist(position.x, position.y, targetX, targetY);
    return distance <= size - 40;
  }

  // Getter methods
  public float getX() {
    return position.x;
  }

  public float getY() {
    return position.y;
  }
}
