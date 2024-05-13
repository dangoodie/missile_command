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
      pg.beginDraw();
      if (isEnemy) {
        pg.stroke(255, 0, 0); // Red
      } else {
        pg.stroke(0, 0, 255); // Blue
      }
      pg.strokeWeight(1);
      pg.line(startingPosition.x, startingPosition.y, position.x, position.y);
      pg.noStroke();
      pg.fill(255);
      pg.ellipse(position.x, position.y, 2, 2);
      pg.endDraw();
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
