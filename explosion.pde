class Explosion {
  PVector position;
  float size = 0;
  float lifespan;
  boolean displayAddedScore = false;
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
    fill(255, 150, 0, lifespan * 5); // Color fades as the explosion "ages"
    ellipse(position.x, position.y, size, size);

    // Diplsay "+25" text on explosion
    if (displayAddedScore) {
      int messageAlpha = 255;
      int messageStartTime = millis();
      int displayDuration = 1000;

      if (messageAlpha > 0) {
        fill(255, 255, 255);
        textFont(spaceGroteskLight);
        textSize(20);
        textAlign(CENTER, CENTER);
        text("+" + scoreMissile(), position.x, position.y);
          
        // Decrease the alpha value over time
        int elapsedTime = millis() - messageStartTime;
        if (elapsedTime < displayDuration) {
          float fadeAmount = map(elapsedTime, 0, displayDuration, 255, 0);
          messageAlpha = int(fadeAmount);
        }
      } else {
        messageAlpha = 0;
      }
    }

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
}
