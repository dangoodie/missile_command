class Base {
  PVector position; // Position of the base
  boolean isAlive; // State of the base
  int ammo = 10; // Ammo of the base
  float speed = 5;

  Base(float x, float y) {
    position = new PVector(x, y);
    isAlive = true;
  }

  boolean hasAmmo() {
    return ammo > 0;
  }

  void fire() {
    antiMissiles.add(new Missile(this.position.x, this.position.y, mouseX, mouseY, speed, false));
    ammo--;
  }

  void display() {
    // Drawing the base
    fill(0, 255, 0);
    noStroke();
    ellipse(position.x, position.y, 20, 20);

    // Displaying the ammo
    fill(255);
    text(ammo, position.x, position.y + 20);
  }

  void destroy() {
    isAlive = false;
  }

  boolean isAlive() {
    return isAlive;
  }

  PVector getPosition() {
    return position;
  }
}
