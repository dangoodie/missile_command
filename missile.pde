class Missile {
  PVector position, velocity, startingPosition;
  boolean isAlive, isEnemy;
  float speed;
  Target target;

  Missile(float x, float y, Target t, float speed, boolean isEnemy) {
    this.position = new PVector(x, y);
    this.startingPosition = new PVector(x, y);
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

      if (isEnemy) {
        stroke(255, 0, 0); // Red
      } else {
        stroke(0, 0, 255); // Blue
      }
      strokeWeight(1);
      line(startingPosition.x, startingPosition.y, position.x, position.y);
      noStroke();
      fill(255);
      ellipse(position.x, position.y, 2, 2);
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
    if (dist(position.x, position.y, target.getPosition().x, target.getPosition().y) < 5) {
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
