class Base implements Target {
  PVector position, missileDestination;
  boolean isAlive;
  int ammo = 10;
  float speed = 5;

  Base(float x, float y) {
    position = new PVector(x, y);
    isAlive = true;
  }

  void fire() {
    antiMissiles.add(new Missile(this.position.x, this.position.y, mouseX, mouseY, speed, false));
    ammo--;
  }

  void display() {
    if (isAlive) {
      // Drawing the base
      fill(0, 255, 0);
      noStroke();
      ellipse(position.x, position.y, 20, 20);

      // Displaying the ammo
      fill(255);
      text(ammo, position.x, position.y + 20);
    }
  }

  void destroy() {
    ammo = 0;
    isAlive = false;
  }

  boolean hasAmmo() {
    return ammo > 0;
  }

  boolean isAlive() {
    return isAlive;
  }

  PVector getPosition() {
    return position;
  }
}
