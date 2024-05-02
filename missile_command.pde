// Game code

ArrayList<Missile> missiles = new ArrayList<Missile>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
Base base;
boolean debug = false; // set to true to enable deubgging features
GameState currentState = GameState.MENU;

// Missile firing logic
int lastFireTime = 0; // Last time a missile was fired
int fireDelay = 1000; // Delay in milliseconds (1 second)

void setupGame() {
  base = new Base(width / 2, height - 50);
  lastFireTime = millis();
}


void drawGame() {
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

  if (mousePressed && base.hasAmmo() && millis() - lastFireTime > fireDelay) {
    base.fire();
    lastFireTime = millis();
  }
}


// main functions 

void setup() {
  size(800, 600);
  setupMenu();
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