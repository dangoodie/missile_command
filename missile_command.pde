GameState currentState = GameState.MENU;

// Game code

ArrayList<Missile> missiles = new ArrayList<Missile>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
Base base;
boolean debug = false; // set to true to enable deubgging features


void setupGame() {
  base = new Base(width / 2, height - 50);
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

void mouseClicked() {
  if (currentState == GameState.GAME) {
    missiles.add(new Missile(base.position.x, base.position.y, mouseX, mouseY));
  }
}
