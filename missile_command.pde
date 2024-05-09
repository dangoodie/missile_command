PImage background, crosshair, destination;
ArrayList<Missile> antiMissiles = new ArrayList<Missile>();
ArrayList<Missile> enemyMissiles = new ArrayList<Missile>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<Base> bases = new ArrayList<Base>();
ArrayList<City> cities = new ArrayList<City>();
boolean debug = false; // Set this to true to enable debugging features
GameState currentState = GameState.MENU;
int lastFireTime = 0; // Last time a missile was fired
int fireDelay = 500; // Delay in milliseconds (1/2 second)

// TODO: Change this later with level switching logic
boolean newLevel = true;
int level = 0;

void setupGame() {
  bases.add(new Base(100, height - 50));
  bases.add(new Base(400, height - 50));
  bases.add(new Base(700, height - 50));

  cities.add(new City(150, height - 50));
  cities.add(new City(250, height - 50));
  cities.add(new City(350, height - 50));
  cities.add(new City(450, height - 50));
  cities.add(new City(550, height - 50));
  cities.add(new City(650, height - 50));

  lastFireTime = millis();

  // Images
  background = loadImage("images/background.png");
  crosshair = loadImage("images/crosshair.png");
  //destination = loadImage("images/destination.png"); TODO: Implement this later
}

void drawGame() {
  image(background, 0, 0);

  // Crosshair
  noCursor();
  image(crosshair, mouseX - crosshair.width / 28, mouseY - crosshair.height / 28, crosshair.width / 14, crosshair.width / 14);

  // Level
  if (newLevel) {
    spawnEnemyMissiles(level);
    newLevel = false;
  }

  // Environment
  for (Base b : bases) {
    b.display();
  }

  for (City c : cities) {
    c.display();
  }

  // Anti-missiles
  for (int i = antiMissiles.size() - 1; i >= 0; i--) {
    Missile m = antiMissiles.get(i);
    m.update();
    m.display();
    m.showDestination();

    if (m.hasHitTarget()) {
      explosions.add(new Explosion(m.position.x, m.position.y, false));
      antiMissiles.remove(i);
    }
  }

  // Enemy missiles
  for (int i = enemyMissiles.size() - 1; i >= 0; i--) {
    Missile m = enemyMissiles.get(i);
    m.update();
    m.display();

    // Destroy targets
    if (m.isAlive == true) {
      if (m.hasHitTarget()) {
        explosions.add(new Explosion(m.position.x, m.position.y, true));
        enemyMissiles.remove(i);
        
        if (m.target instanceof Base) {
          Base b = (Base) m.target;
          b.destroy();
        } else if (m.target instanceof City) {
          City c = (City) m.target;
          c.destroy();
        }
      }
    }
  }

  // Explosions
  for (int i = explosions.size() - 1; i >= 0; i--) {
    Explosion e = explosions.get(i);
    e.update();
    e.display();

    // Check if there are any enemy missiles within explosion radius
    for (int j = enemyMissiles.size() - 1; j >= 0; j--) {
      Missile em = enemyMissiles.get(j);

      if (e.detectCollisionWithinRadius(em.position.x, em.position.y)) {
        em.death();
      }
    }

    if (e.isDead()) {
      explosions.remove(i);
    }
  }

  if (mousePressed && millis() - lastFireTime > fireDelay) {
    lastFireTime = millis();
    Base closestBase = getClosestBase();
    if (closestBase != null) {
      closestBase.fire();
    }
  }
}

// Main functions
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

Base getClosestBase() {
  Base closestBase = null;
  float closestDistance = Float.MAX_VALUE;

  for (Base b : bases) {
    if (!b.hasAmmo()) {
      continue;
    }

    if (!b.isAlive()) {
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

void spawnEnemyMissiles(int level) {
  // TODO: Implement level logic
  for (int i = 0; i < 6; i++) {
    Target t = pickValidTarget();
    float r = random(width);
    float speed = 1;
    enemyMissiles.add(new Missile(r, 0, t, speed, true)); 
  }
}

Target pickValidTarget() {
  ArrayList<Target> targets = new ArrayList<Target>();

  for (int i = 0; i < bases.size(); i++) {
    if (bases.get(i).isAlive()) {
      targets.add(bases.get(i));
    }
  }

  for (int i = 0; i < cities.size(); i++) {
    if (cities.get(i).isAlive()) {
      targets.add(cities.get(i));
    }
  }

  int selection = int(random(targets.size()));
  return targets.get(selection);
}
