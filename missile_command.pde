PImage background, crosshair, destination;
SoundFile lazer, game_bground_music, menu_music, start_sound;
ArrayList<Missile> antiMissiles = new ArrayList<Missile>();
ArrayList<Missile> enemyMissiles = new ArrayList<Missile>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<Base> bases = new ArrayList<Base>();
ArrayList<City> cities = new ArrayList<City>();
boolean debug = false; // Set this to true to enable debugging features
GameState currentState = GameState.MENU;

// Anti Missile variables
int lastFireTime = 0; // Last time a missile was fired
int fireDelay = 500; // Delay in milliseconds (1/2 second)

// Enemy Missile variables
int missileLevelCount; // Number of missiles to fire
int missilesRemaining; // Number of missiles remaining to fire
float missileSpeed = 0.5; // Speed of the missile
float missileSpeedIncrement = 0.1; // Speed increment per level
int missileDelay; // Delay between missiles
int missileDelayMin = 1000; // Minimum delay in milliseconds (1 second)
int missileDelayMax = 5000; // Maximum delay in milliseconds (5 second)
int missilesDestroyed = 0; // Number of missiles destroyed

// Level variables
boolean newLevel = true;
int level = 1;

// Score variables
int score = 0;
int highScore = 0;

// Glow Effect
PGraphics pg;
PImage glowImage;
int glowEffectAmount = 127; // 0 - 255


int game_start_time;

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

  // Generate missile count
  missileLevelCount = generateLevelMissileCount(level);
  missilesRemaining = missileLevelCount;
  missileDelay = nextMissileDelay();
  missilesDestroyed = 0;
}

void drawGame() {
  pg.beginDraw();
  pg.image(background, 0, 0);
  pg.endDraw();

  if (millis() > (game_start_time) + 5000 && game_bground_music.isPlaying() == false) {
    SoundController(game_bground_music, 0.2, true); 
  }

   // Check if all cities have been destroyed
  if (checkGameOver()) {
    currentState = GameState.GAME_OVER;
    setupGameOver();
  }

  // Level progression
  if (newLevel) {
    newLevel = false;
    missileLevelCount = generateLevelMissileCount(level);
    missilesRemaining = missileLevelCount;
    missileDelay = nextMissileDelay();
  }

  // Enemy missile generation
  if (millis() > missileDelay && missilesRemaining > 0) {
    missileDelay = nextMissileDelay();
    shootMissiles(loadMissiles());
  }

  // Check if all missiles have been destroyed
  if (missilesDestroyed == missileLevelCount && enemyMissiles.size() == 0 && explosions.size() == 0 && antiMissiles.size() == 0){
    newLevel();
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


  // Environment
  for (Base b : bases) {
    b.display();
  }

  for (City c : cities) {
    c.display();
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
        missilesDestroyed++;
        
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
        explosions.add(new Explosion(em.position.x, em.position.y, false));
        score += scoreMissile();
        missilesDestroyed++;
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
      SoundController(lazer, 0.2, false);
    }
  }

  // Crosshair
  noCursor();
  pg.beginDraw();
  pg.image(crosshair, mouseX - crosshair.width / 28, mouseY - crosshair.height / 28, crosshair.width / 14, crosshair.width / 14);
  pg.endDraw();

  displayScoreboard();
  updateHighScore();
}

// Main functions
void setup() {
  size(800, 600, P2D);
    // Images
  background = loadImage("images/background.png");
  crosshair = loadImage("images/crosshair.png");
  destination = loadImage("images/destination.png");

  // Sounds
  menu_music = new SoundFile(this, "sounds/menu-music.wav");
  start_sound = new SoundFile(this, "sounds/game-start-sound.wav");
  lazer = new SoundFile(this, "sounds/powerful-laser.wav");
  game_bground_music = new SoundFile(this, "sounds/background-music-1.wav");

  pg = createGraphics(width,height,P2D);
  pg.beginDraw();
  pg.smooth();
  pg.stroke(255); 
  pg.strokeWeight(2); 
  pg.endDraw();

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
      drawPause();
      break;
  }

  glowImage = pg.get(0,0,pg.width,pg.height);
  glowImage.resize(0, pg.width/4);
  glowImage.filter(BLUR,1);
  glowImage.resize(0,pg.height);

  tint(glowEffectAmount);
  image(glowImage,0,0);
  blendMode(ADD);
  tint(255);
  image(pg,0,0);
  blendMode(BLEND);
}

void keyPressed() {
  if (key == ESC) {
    key = 0; // Prevent default behavior

    if (currentState == GameState.PAUSE) {
      currentState = GameState.GAME;
    } else if (currentState == GameState.GAME) {
      currentState = GameState.PAUSE;
      setupPause();
    }
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

int generateLevelMissileCount(int level) {
  return 5 + (level - 1) * 2;
}

int loadMissiles() {
    int missiles = int(random(1, missilesRemaining));
    missilesRemaining -= missiles;
    if (debug) println("Missiles remaining: " + missilesRemaining + " Missiles loaded: " + missiles);
    return missiles;
}

void shootMissiles(int count) {
  int missileCount = count;
  for (int i = 0; i < missileCount; i++) {
    Target t = pickValidTarget();
    float r = random(width);
    float speed = missileSpeed + ((level - 1) * missileSpeedIncrement);
    enemyMissiles.add(new Missile(r, 0, t, speed, true)); 
  }
}

int nextMissileDelay() {
  return millis() + (int) random(missileDelayMin, missileDelayMax);
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
  pg.fill(255);
  pg.textSize(20);
  pg.textAlign(RIGHT, TOP);
  pg.text("Level: " + level + "\nScore: " + score,  width - scoreOffset, 0 + scoreOffset);
}

void updateHighScore() {
  if (score > highScore) {
    highScore = score;
  }
}

int scoreMissile() {
  return 100 + 100 * ((level - 1) / 2);
}
