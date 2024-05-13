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
    Target t = new LocationTarget(new PVector(mouseX, mouseY));
    antiMissiles.add(new Missile(this.position.x, this.position.y, t, speed, false));
    ammo--;
  }

  void display() {
    pg.beginDraw();
    if (isAlive) {
      // Drawing the base
      pg.fill(0, 255, 0);
      pg.noStroke();
      pg.ellipse(position.x, position.y, 20, 20);

      // Displaying the ammo
      pg.fill(255);
      pg.text(ammo, position.x, position.y + 20);
    } else {
      // display destroyed base
    }
    pg.endDraw();
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
