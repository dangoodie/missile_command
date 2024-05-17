class Base implements Target {
  PVector position;
  boolean isAlive;
  int ammo = 10;
  float speed = 5;

  Base(float x, float y) {
    position = new PVector(x, y);
    isAlive = true;
  }

  void fire() {
    Target t = new LocationTarget(new PVector(mouseX, mouseY));
    PVector offPosition = this.getPosition();
    antiMissiles.add(new Missile(offPosition.x, offPosition.y, t, speed, false));
    totalAntiMissilesFired++;
    ammo--;
  }

  float calculateAngleToMouse() {
    PVector direction = PVector.sub(new PVector(mouseX, mouseY), position);
    return direction.heading();
  }

  void display() {
    if (isAlive) {
      // Drawing the turret barrel
      float angle = calculateAngleToMouse();
      float barrelLength = 30;
      float barrelWidth = 8;

      pushMatrix();
      translate(position.x, position.y + 5);
      rotate(angle);
      fill(purple);
      rectMode(CORNER);
      rect(0, -barrelWidth / 2, barrelLength, barrelWidth);
      popMatrix();

      // Drawing the base
      noStroke();
      imageMode(CENTER);
      image(base, this.position.x, this.position.y, 60, 50);

      // Displaying the ammo
      fill(255);
      textFont(spaceGroteskLight);
      textSize(20);
      text(ammo, position.x, position.y + 34);
    } else {
      imageMode(CENTER);
      image(destroyedBase, this.position.x, this.position.y, 60, 50);
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
    int yOff = 5;
    PVector offPosition = new PVector(this.position.x, this.position.y + yOff);
    return offPosition;
  }
}
