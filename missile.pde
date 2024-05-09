class Missile {
  PVector position, velocity;
  boolean isAlive, isEnemy;
  float speed;
  Target target;

  Missile(float x, float y, Target t, float speed, boolean isEnemy) {
    this.position = new PVector(x, y);
    this.target = t;
    this.velocity = PVector.sub(t.getPosition(), position);
    this.isAlive = true;

    this.speed = speed;
    this.isEnemy = isEnemy;

    velocity.normalize();
    velocity.mult(speed);
  }

  void update() {
    position.add(velocity);
  }

  void display() {
    if (isAlive) {
      stroke(255, 0, 0);
      strokeWeight(3);
      line(position.x, position.y, position.x - velocity.x, position.y - velocity.y);
    }
  }

  void showDestination() {
    if (!isEnemy) {
      target.display();
    }
  }

  void death() {
    isAlive = false;
  }

  boolean hasHitTarget() {
    if (dist(position.x, position.y, target.getPosition().x, target.getPosition().y) < 10) {
      return true;
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
