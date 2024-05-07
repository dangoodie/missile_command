class Missile {
  PVector position;
  PVector target;
  PVector velocity;
  float speed;
  boolean isEnemy;

  Missile(float x, float y, float tx, float ty, float speed, boolean isEnemy) {
    position = new PVector(x, y);
    target = new PVector(tx, ty);
    velocity = PVector.sub(target, position);

    this.speed = speed;
    this.isEnemy = isEnemy;

    velocity.normalize();
    velocity.mult(speed);
  }

  void update() {
    position.add(velocity);
  }

  void display() {
    stroke(255, 0, 0);
    strokeWeight(2);
    line(position.x, position.y, position.x - velocity.x, position.y - velocity.y);
  }

  boolean hasHitTarget() {
    if (isEnemy) {
      // Check if the missile's position overlaps with any target's position
      for (Base b : bases) {
        if (b.isAlive() && dist(position.x, position.y, b.getPosition().x, b.getPosition().y) < 10) {
          return true;
        }
      }

      for (City c : cities) {
        if (c.isAlive() && dist(position.x, position.y, c.getPosition().x, c.getPosition().y) < 10) {
          return true;
        }
      }
    } else {
      return dist(position.x, position.y, target.x, target.y) < 10;
    }

    return false;
  }

  // Getter methods
  public float getX() {
    return position.x;
  }

  public float getY() {
    return position.y;
  }
}
