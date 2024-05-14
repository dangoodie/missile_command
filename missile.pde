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
      int strokeColor;
      if (isEnemy) {
        strokeColor = red; // Red
      } else {
        strokeColor = blue; // Blue
      }

      stroke(strokeColor);
      strokeWeight(1);
      
      // Calculate alpha value based on distance traveled
      float alphaValue = map(position.dist(startingPosition), 0, target.getPosition().dist(startingPosition), 255, 0);
      stroke(red(strokeColor), green(strokeColor), blue(strokeColor), alphaValue);
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
}
