import processing.sound.*;

Sound master;
boolean muted = false;

int red = 0xFF39A4;
int blue = 0x25C4F8;
PFont friendOrFoeTallBB, spaceGroteskLight;
PImage line, background, menuBackground, gameOverBackground, crosshair, destination, city, destroyed_city, pause;
SoundFile game_bground_music, menu_music, start_sound, game_over_sound;
SoundFile lazer, explosion_sound, enemy_explode_sound, base_destroyed_sound, button_click;
ArrayList<Missile> antiMissiles = new ArrayList<Missile>();
ArrayList<Missile> enemyMissiles = new ArrayList<Missile>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<Base> bases = new ArrayList<Base>();
ArrayList<City> cities = new ArrayList<City>();
ArrayList<ScoreText> scoreText = new ArrayList<ScoreText>();
boolean debug = false; // Set this to true to enable debugging features
int game_start_time;
GameState currentState = GameState.MENU;

// Anti Missile Variables
int lastFireTime = 0; // Last time a missile was fired
int fireDelay = 500; // Delay in milliseconds (1/2 second)

// Enemy Missile Variables
int missileLevelCount; // Number of missiles to fire
int missilesRemaining; // Number of missiles remaining to fire
float missileSpeed = 0.5; // Speed of the missile
float missileSpeedIncrement = 0.1; // Speed increment per level
int missileDelay; // Delay between missiles
int missileDelayMin = 1000; // Minimum delay in milliseconds (1 second)
int missileDelayMax = 5000; // Maximum delay in milliseconds (5 second)
int missilesDestroyed = 0; // Number of missiles destroyed

// Level Variables
boolean newLevel = true;
int level = 1;

// Score Variables
int score = 0;
int highScore = 0;

void setupGame() {
  buildBases();
  buildCities();
  lastFireTime = millis();

  // Generate missile count
  missileLevelCount = generateLevelMissileCount(level);
  missilesRemaining = missileLevelCount;
  missileDelay = nextMissileDelay();
  missilesDestroyed = 0;
}

void buildBases() {
  bases.add(new Base(92, height - 57));
  bases.add(new Base(400, height - 57));
  bases.add(new Base(708, height - 57));
}

void buildCities() {
  cities.add(new City(165, height - 51));
  cities.add(new City(246, height - 51));
  cities.add(new City(327, height - 51));
  cities.add(new City(473, height - 51));
  cities.add(new City(554, height - 51));
  cities.add(new City(635, height - 51));
}

void drawGame() {
  image(background, 0, 0);
  image(line, 0, 38);

  // Background music
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

  for (int i = scoreText.size() - 1; i >= 0; i--) {
    ScoreText st = scoreText.get(i);
    st.display();
    if (st.isExpired()) {
      scoreText.remove(i);
    }
  }

  // Anti-missiles
  for (int i = antiMissiles.size() - 1; i >= 0; i--) {
    Missile m = antiMissiles.get(i);
    m.update();
    m.display();
    m.showDestination();

    if (m.hasHitTarget()) {
      explosions.add(new Explosion(m.position, false));
      antiMissiles.remove(i);
      SoundController(explosion_sound, 0.3, false);
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
        explosions.add(new Explosion(m.position, true));
        SoundController(base_destroyed_sound, 0.3, false);
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
        SoundController(enemy_explode_sound, 0.8, false);

        em.death();
        enemyMissiles.remove(j);
        explosions.add(new Explosion(em.position, false));
        scoreText.add(new ScoreText(em.position, scoreMissile()));

        // Score

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
  image(crosshair, mouseX - crosshair.width / 28, mouseY - crosshair.height / 28, crosshair.width / 14, crosshair.width / 14);

  // Score
  displayScoreboard();
  updateHighScore();
}

// Main functions
void setup() {
  size(800, 600);

  // Fonts
  friendOrFoeTallBB = createFont("fonts/FriendOrFoeTallBB/Friend or Foe Tall BB/Friend or Foe Tall BB.ttf", 32);
  spaceGroteskLight = createFont("fonts/SpaceGrotesk/static/SpaceGrotesk-Light.ttf", 32);

  // Images
  line = loadImage("images/line.png");
  background = loadImage("images/background.png");
  menuBackground = loadImage("images/menu_background.png");
  gameOverBackground = loadImage("images/game_over_background.png");
  crosshair = loadImage("images/crosshair.png");
  destination = loadImage("images/destination.png");
  city = loadImage("images/neonCity.png");
  destroyed_city = loadImage("images/destroyedCity.png");
  pause = loadImage("images/pause.png");

  // Sounds
  master = new Sound(this);
  menu_music = new SoundFile(this, "sounds/menu-music.wav");
  start_sound = new SoundFile(this, "sounds/game-start-sound.wav");
  lazer = new SoundFile(this, "sounds/powerful-laser.wav");
  game_bground_music = new SoundFile(this, "sounds/background-music-1.wav");
  game_over_sound = new SoundFile(this, "sounds/game-over-sound.wav");
  explosion_sound = new SoundFile(this, "sounds/explosion.wav");
  enemy_explode_sound = new SoundFile(this, "sounds/enemy-explode3.wav"); // Experiment with 2 and 3
  base_destroyed_sound = new SoundFile(this, "sounds/base-destroyed.wav"); // TODO: Search for a new sound
  button_click = new SoundFile(this, "sounds/button_click.mp3");

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
}

void keyPressed() {
  if (key == ESC) {
    key = 0; // Prevent default behavior

    if (currentState == GameState.PAUSE) {
      game_bground_music.amp(0.2);
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

// This function picks a random target that has not been selected yet.
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
  buildBases();

  // Generate missile count
  missileLevelCount = generateLevelMissileCount(level);
  missilesRemaining = missileLevelCount;
  missileDelay = nextMissileDelay();
  missilesDestroyed = 0;
}

void newGame() {
  level = 1;
  score = 0;
  newLevel = true;
  game_start_time = millis();

  enemyMissiles.clear();
  antiMissiles.clear();
  explosions.clear();
  bases.clear();
  cities.clear();
  SoundController(start_sound, 0.4, false);
  setupGame();
}

// Scoreboard helper functions
void displayScoreboard() {
  // Level
  fill(color(red(blue), green(blue), blue(blue)));
  textFont(spaceGroteskLight);
  textSize(15);
  textAlign(CENTER, TOP);
  text("LVL " + level, width/2, 15);

  // Score
  fill(255);
  textFont(spaceGroteskLight);
  textSize(30);
  textAlign(CENTER, TOP);
  text(score, width/2, 35);
}

void updateHighScore() {
  if (score > highScore) {
    highScore = score;
  }
}

int scoreMissile() {
  return 25 + 25 * ((level - 1) / 2);
}
