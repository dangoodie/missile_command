// Classes 

class Base {
  PVector position; // Position of the base
  boolean isActive; // State of the base

  Base(float x, float y) {
    position = new PVector(x, y);
    isActive = true;
  }

  void display() {
    fill(0, 255, 0);
    noStroke();
    ellipse(position.x, position.y, 20, 20); // Drawing the base
  }

  void destroy() {
    isActive = false;
  }
}

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

class Explosion {
  PVector position;
  float lifespan = 50;
  float size = 0;

  Explosion(float x, float y) {
    position = new PVector(x, y);
  }

  void update() {
    lifespan -= 1;
    size += 2; // Increase the size of the explosion
  }

  void display() {
    noStroke();
    fill(255, 150, 0, lifespan * 5); // Color fades as the explosion "ages"
    ellipse(position.x, position.y, size, size);
  }

  boolean isDead() {
    return lifespan < 0;
  }
}

// Game code

ArrayList<Missile> missiles = new ArrayList<Missile>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
Base base;

void setup() {
  size(800, 600);
  base = new Base(width / 2, height - 50);
}

void draw() {
  background(0);
  base.display();

  for (int i = missiles.size() - 1; i >= 0; i--) {
    Missile m = missiles.get(i);
    m.update();
    m.display();
    if (m.hasHitTarget()) {
      explosions.add(new Explosion(m.position.x, m.position.y));
      missiles.remove(i);
    }
  }

  for (int i = explosions.size() - 1; i >= 0; i--) {
    Explosion e = explosions.get(i);
    e.update();
    e.display();
    if (e.isDead()) {
      explosions.remove(i);
    }
  }
}

void mouseClicked() {
  missiles.add(new Missile(base.position.x, base.position.y, mouseX, mouseY));
}
