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
    antiMissiles.add(new Missile(this.position.x, this.position.y, t, speed, false));
    ammo--;
  }

  float calculateAngleToMouse() {
    PVector direction = PVector.sub(new PVector(mouseX, mouseY), position);
    return direction.heading();
  }

  void display() {
    if (isAlive) {
      // Drawing the base
      fill(0, 255, 0);
      noStroke();
      rectMode(CENTER);
      rect(position.x, position.y, 60, 50);
      rectMode(CORNER);

       // Drawing the turret barrel
      float angle = calculateAngleToMouse();
      float barrelLength = 40;
      PVector barrelEnd = PVector.fromAngle(angle).mult(barrelLength).add(position);
      stroke(255, 0, 0);
      strokeWeight(4);
      line(position.x, position.y, barrelEnd.x, barrelEnd.y);
      noStroke();

      // Displaying the ammo
      fill(255);
      textFont(spaceGroteskLight);
      textSize(20);
      text(ammo, position.x, position.y + 34);
    } else {
      // Display destroyed base
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
