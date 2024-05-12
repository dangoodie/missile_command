PImage background, crosshair, destination;
ArrayList<Missile> antiMissiles = new ArrayList<Missile>();
ArrayList<Missile> enemyMissiles = new ArrayList<Missile>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<Base> bases = new ArrayList<Base>();
ArrayList<City> cities = new ArrayList<City>();
boolean debug = false; // Set this to true to enable debugging features
GameState currentState = GameState.MENU;

// Missile variables
int lastFireTime = 0; // Last time a missile was fired
int fireDelay = 500; // Delay in milliseconds (1/2 second)

// Level variables
boolean newLevel = true;
int level = 1;

// Score variables
int score = 0;
int highScore = 0;

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
  destination = loadImage("images/destination.png");
}

void drawGame() {
  image(background, 0, 0);

  // Crosshair
  noCursor();
  image(crosshair, mouseX - crosshair.width / 28, mouseY - crosshair.height / 28, crosshair.width / 14, crosshair.width / 14);

   // Check if all cities have been destroyed
  if (checkGameOver()) {
    currentState = GameState.GAME_OVER;
    setupGameOver();
  }

  // Level
  if (newLevel) {
    spawnEnemyMissiles(level);
    newLevel = false;
  }

  // Check if all missiles have been destroyed
  if (enemyMissiles.size() == 0){
    newLevel();
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
        enemyMissiles.remove(j);
        score += scoreMissile();
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


  displayScoreboard();
  updateHighScore();
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
    case GAME_OVER:
      drawGameOver();
      break;
    case PAUSE:
      //drawPause();
      break;
  }
}

void keyPressed() {
  if (key == ESC) {
    key = 0; // Prevent default behavior
    currentState = GameState.MENU;
  }
}

// Enemy missile helper functions

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
  int missileCount = 4 + 1 * level;
  for (int i = 0; i < missileCount; i++) {
    Target t = pickValidTarget();
    float r = random(width);
    float speed = 0.5 + ((level - 1) * 0.1);
    enemyMissiles.add(new Missile(r, 0, t, speed, true)); 
  }
}

// This function picks a random target that has not been selected yet
// If all targets have been selected, it clears the selected targets and picks a new target

ArrayList<Target> selectedTargets = new ArrayList<Target>();

Target pickValidTarget() {
  ArrayList<Target> validTargets = new ArrayList<Target>();

  // Collect all alive targets from bases and cities
  for (int i = 0; i < bases.size(); i++) {
    if (bases.get(i).isAlive()) {
      validTargets.add(bases.get(i));
    }
  }

  for (int i = 0; i < cities.size(); i++) {
    if (cities.get(i).isAlive()) {
      validTargets.add(cities.get(i));
    }
  }

  // Filter to get only unselected targets
  ArrayList<Target> unselectedTargets = new ArrayList<Target>();
  for (Target t : validTargets) {
    if (!selectedTargets.contains(t)) {
      unselectedTargets.add(t);
    }
  }

  // Reset if all targets were selected
  if (unselectedTargets.isEmpty() && !validTargets.isEmpty()) {
    selectedTargets.clear();
    unselectedTargets.addAll(validTargets);  // Use addAll for efficiency
  }

  // If there are no unselected targets and no valid targets, return null
  if (unselectedTargets.isEmpty()) {
    return null;
  }

  // Correct the selection index to use the size of unselectedTargets
  int selection = (int) random(unselectedTargets.size());
  Target selected = unselectedTargets.get(selection);
  selectedTargets.add(selected);
  return selected;
}


// New level helper functions

void newLevel() {
  level++;
  newLevel = true;
  enemyMissiles.clear();
  antiMissiles.clear();
  explosions.clear();
  bases.clear();
  cities.clear();
  setupGame();
}

void newGame() {
  level = 1;
  score = 0;
  newLevel = true;
  enemyMissiles.clear();
  antiMissiles.clear();
  explosions.clear();
  bases.clear();
  cities.clear();
  setupGame();
}

// Scoreboard helper functions

int scoreOffset = 8;
void displayScoreboard() {
  fill(255);
  textSize(20);
  textAlign(RIGHT, TOP);
  text("Level: " + level + "\nScore: " + score,  width - scoreOffset, 0 + scoreOffset);
}

void updateHighScore() {
  if (score > highScore) {
    highScore = score;
  }
}

int scoreMissile() {
  return 100 + 100 * ((level - 1) / 2);
}

