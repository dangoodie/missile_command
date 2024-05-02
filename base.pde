class Base {
  PVector position; // Position of the base
  boolean isActive; // State of the base
  int ammo = 10; // Ammo of the base

  Base(float x, float y) {
    position = new PVector(x, y);
    isActive = true;
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
    isActive = false;
  }

  boolean isActive() {
    return isActive;
  }

  PVector getPosition() {
    return position;
  }
}