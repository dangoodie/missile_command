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
    velocity.normalize();
    this.speed = speed;
    velocity.mult(speed);
    this.isEnemy = isEnemy;
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
    return PVector.dist(position, target) < 10;
  }
}
