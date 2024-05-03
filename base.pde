class Base {
  PVector position; // Position of the base
  boolean isAlive; // State of the base
  int ammo = 10; // Ammo of the base

  Base(float x, float y) {
    position = new PVector(x, y);
    isAlive = true;
  }

  boolean hasAmmo() {
    return ammo > 0;
  }

  void fire() {
    missiles.add(new Missile(this.position.x, this.position.y, mouseX, mouseY));
    ammo--;
  }

  void display() {
    fill(0, 255, 0);
    noStroke();
    ellipse(position.x, position.y, 20, 20); // Drawing the base
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