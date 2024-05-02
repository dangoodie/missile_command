// Classes 

class Button {
  float x, y; // Position
  float w, h; // Width and height
  String label; // Button text
  Runnable action; // Action to perform on click
  
  // default values that can be changed
  color bgColor = 200;
  color bgHoverColor = 160;
  color textColor = 0;
  int textSize = 20;

  Button(float x, float y, float w, float h, String label, Runnable action) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.action = action;
  }

  void display() {
    if (this.overButton()) {
      fill(bgHoverColor);
    } else {
      fill(bgColor);  
    }
    rect(x, y, w, h, 10); // Draw button with rounded corners
    fill(textColor);
    textSize(textSize);
    textAlign(CENTER, CENTER);
    text(label, x + w/2, y + h/2);
  }

  boolean overButton() {
    // Check if the mouse is over the button
    
    return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
  }

  void checkClick() {
    if (overButton() && mousePressed) {
      action.run();
    }
  }
}

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

enum GameState {
  MENU, GAME
}

GameState currentState = GameState.MENU;

// Menu code

Button startButton;
Button quitButton;

void setupMenu() {
  // Define buttons with actions
  startButton = new Button(width/2 - 100, height/2 - 50, 200, 50, "Start", () -> {
    currentState = GameState.GAME;
    setupGame();
    });
  startButton.bgColor = color(70, 195, 76);
  startButton.bgHoverColor = color(71,159,120);
  quitButton = new Button(width/2 - 100, height/2 + 20, 200, 50, "Quit", () -> {
    exit();
  });
  quitButton.bgColor = color(70,195,76);
  quitButton.bgHoverColor = color(71,159,120);
}

void drawMenu() {
  background(0);
  startButton.display();
  quitButton.display();
  startButton.checkClick();
  quitButton.checkClick();
}


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
