class Explosion {
  PVector position;
  float size = 0;
  float lifespan;
  boolean isEnemy;

  Explosion(PVector position, boolean isEnemy) {
    this.position = position;
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
    if (isEnemy) {
      image(enemy_explosion, position.x - size/2, position.y - size/2, size, size);
    } else {
      image(antimissile_explosion, position.x - size/2, position.y - size/2, size, size);
    }
  }

  boolean isDead() {
    return lifespan < 0;
  }

  boolean detectCollisionWithinRadius(float targetX, float targetY) {
    float distanceSq = sq(targetX - position.x) + sq(targetY - position.y);
    float radiusSq = sq(size / 2);
    return distanceSq <= radiusSq;
  }
}
