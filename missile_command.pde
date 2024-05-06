PImage background, crosshair, antimissile_unexploded, antimissile_exploded;
ArrayList<Missile> antiMissiles = new ArrayList<Missile>();
ArrayList<Missile> enemyMissiles = new ArrayList<Missile>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<Base> bases = new ArrayList<Base>(); // Anti-missile batteries
ArrayList<City> cities = new ArrayList<City>();
boolean debug = false; // Set this to true to enable debugging features
GameState currentState = GameState.MENU;

// Anti-missile firing logic
int lastFireTime = 0; // Last time a missile was fired
int fireDelay = 1000; // Delay in milliseconds (1 second)

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

//  // Images
//  Uncomment once these are available 
//  background = loadImage("images/background.png");
//  crosshair = loadImage("images/crosshair.png");
//  antimissile_unexploded = loadImage("images/antimissile_unexploded.png");
//  antimissile_exploded = loadImage("images/antimissile_exploded.png");
}

// TODO: Change this later with level switching logic
boolean newLevel = true;
int level = 0;

void drawGame() {
  //image(background, 0, 0); // uncomment once image is available
  background(0);

  // Crosshair
  noCursor();
  //image(crosshair, mouseX - crosshair.width / 28, mouseY - crosshair.height / 28, crosshair.width / 14, crosshair.width / 14); // uncomment once image is available
  
  if (newLevel) {
    spawnEnemyMissiles(level);
    newLevel = false;
  }

  for (Base b : bases) {
    b.display();
  }

  for (City c : cities) {
    c.display();
  }

  for (int i = antiMissiles.size() - 1; i >= 0; i--) {
    Missile m = antiMissiles.get(i);
    m.update();
    m.display();
    if (m.hasHitTarget()) {
      explosions.add(new Explosion(m.position.x, m.position.y));
      antiMissiles.remove(i);
    }
  }

  for (int i = enemyMissiles.size() - 1; i >= 0; i--) {
    Missile m = enemyMissiles.get(i);
    m.update();
    m.display();
    if (m.hasHitTarget()) {
      explosions.add(new Explosion(m.position.x, m.position.y));
      enemyMissiles.remove(i);
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

Base getClosetBase() {
  Base closestBase = null;
  float closestDistance = Float.MAX_VALUE;

  for (Base b : bases) {
    if (!b.hasAmmo()) {
      continue;
    }

    if (!b.isAlive()){
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
	for (int i = 0; i < 6; i++) {
		PVector t = pickValidTarget();
		float r = random(width);
    float speed = 1;
		enemyMissiles.add(new Missile(r, 0, t.x, t.y, speed, true)); 
	}
}

PVector pickValidTarget() {
	ArrayList<PVector> targets = new ArrayList<PVector>();
	for (int i = 0; i < bases.size(); i++) {
		if (bases.get(i).isAlive()) {
			targets.add(bases.get(i).getPosition());
		}
	}
	for (int i = 0; i < cities.size(); i++) {
		if (cities.get(i).isAlive()) {
			targets.add(cities.get(i).getPosition());
		}
	}
	int selection  = int(random(targets.size()));

	return targets.get(selection);
}
