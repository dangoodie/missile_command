// Game code

ArrayList<Missile> missiles = new ArrayList<Missile>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<Base> bases = new ArrayList<Base>();
ArrayList<City> cities = new ArrayList<City>();
boolean debug = false; // set to true to enable deubgging features
GameState currentState = GameState.MENU;

// Missile firing logic
int lastFireTime = 0; // Last time a missile was fired
int fireDelay = 1000; // Delay in milliseconds (1 second)

void setupGame() {
  bases.add(new Base(width / 2, height - 50));
  bases.add(new Base(width / 4, height - 50));
  bases.add(new Base(width * 3 / 4, height - 50));

  // Create 6 cities at the bottom of the screen
  for (int i = 0; i < 6; i++) {
    cities.add(new City(i * width / 6 + width / 12, height - 50));
  }

  lastFireTime = millis();
}


void drawGame() {
  background(0);
  for (Base b : bases) {
    b.display();
  }

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

  if (mousePressed && millis() - lastFireTime > fireDelay) {
    lastFireTime = millis();
    Base closestBase = getClosetBase();
    if (closestBase != null) {
      closestBase.fire();
    }
  }
}


// main functions 

void setup() {
  size(800, 600);
  setupMenu();
  frameRate(60);
}

void draw() {
  switch (currentState) {
    case MENU:
      drawMenu();
      break;
    case GAME:
      drawGame();
      break;
  }
}

void keyPressed() {
  if (key == ESC) {
    key = 0; // Prevent default behavior
    currentState = GameState.MENU;
  }
}

// helper functions
Base getClosetBase() {
  Base closestBase = null;
  float closestDistance = Float.MAX_VALUE;
  for (Base b : bases) {
    if (!b.hasAmmo()) {
      continue;
    }
    if (!b.isActive()){
      continue;
    }
    PVector mouse = new PVector(mouseX, mouseY);
    PVector base = b.getPosition();
    float distance = PVector.dist(mouse, base);
    if (distance < closestDistance) {
      closestBase = b;
      closestDistance = distance;
    }
  }
  return closestBase;
}