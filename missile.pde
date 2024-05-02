class Missile {
  PVector position;
  PVector target;
  PVector velocity;
  float speed = 5.0;

  Missile(float x, float y, float tx, float ty) {
    position = new PVector(x, y);
    target = new PVector(tx, ty);
    velocity = PVector.sub(target, position);
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
    return PVector.dist(position, target) < 10;
  }
}