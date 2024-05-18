/*** Missile Command ***

COSC101, Assignment 3 - Trimester 1 (2024)
Group Members: Daniel Gooden, Tanya Boye, Zoë Koh

Missile Command is a classic Atari arcade game created in 1980. 

To run the game:
  - As well as the base functionality that is standard with Prcoessing,
    there is one additional library required in order to run the game.
    To install, go to: Sketch > Import Library > Manage Libraries,
    then search and install "Sound" by The Processing Foundation.
  - Run "missile_command.pde" to play the game.

Additional information including gameplay description and credits can
be found in the README.md file found within the Missile Command folder.
*/

import processing.sound.*;

int red = 0xFF39A4;
int blue = 0x25C4F8;
int purple = #CC6CE7;
PFont friendOrFoeTallBB, spaceGroteskLight;
PImage ground, separator, pause, crosshair, destination, background, menuBackground, gameOverBackground;
PImage enemyExplosion, antiMissileExplosion, city, destroyedCity, base, destroyedBase;
PImage tempBackgroundImage; // Variable to capture and store a background image
Sound master;
SoundFile gameBackgroundMusic, menuMusic, startSound, gameOverSound;
SoundFile lazer, explosionSound, enemyExplodeSound, baseDestroyedSound, buttonClickSound;
ArrayList<Missile> antiMissiles = new ArrayList<Missile>();
ArrayList<Missile> enemyMissiles = new ArrayList<Missile>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<ScoreText> scoreText = new ArrayList<ScoreText>();
ArrayList<Base> bases = new ArrayList<Base>();
ArrayList<City> cities = new ArrayList<City>();
boolean mute = false; // Set this to true to mute the game
boolean debug = false; // Set this to true to enable debugging features
int game_start_time; // Time when the game starts
GameState currentState = GameState.MENU; // Initial state

// Anti Missile Variables
int totalAntiMissilesFired, leftOverAmmo;
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
  imageMode(CORNER);
  image(background, 0, 0);
  image(ground, 0, 38);

  // Count extra ammo
  leftOverAmmo = 30 - totalAntiMissilesFired;

  // Background music
  if (millis() > (game_start_time) + 5000 && gameBackgroundMusic.isPlaying() == false) {
    SoundController(gameBackgroundMusic, 0.2, true); 
  }

  // Check if all cities have been destroyed
  if (checkGameOver()) {
    currentState = GameState.GAME_OVER;
    setupGameOver();
  }

  // Level progression
  if (newLevel) {
    // Score screen
    if (level > 1) {
      currentState = GameState.SCORE;
      totalAntiMissilesFired = 0;
      survivingCities = 0;
      getBonusPointsLevel();
      score += calculateBonusPoints();
      setupScoreScreen();
    }

    // Next level
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
  if (
    missilesDestroyed == missileLevelCount && 
    enemyMissiles.size() == 0 && 
    explosions.size() == 0 && 
    antiMissiles.size() == 0 && 
    scoreText.size() == 0
  ) {
    newLevel();
  }

  // Score text on explosions
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
      SoundController(explosionSound, 0.3, false);
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
        SoundController(baseDestroyedSound, 0.3, false);
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
        SoundController(enemyExplodeSound, 0.8, false);

        em.death();
        enemyMissiles.remove(j);
        explosions.add(new Explosion(em.position, false));
        scoreText.add(new ScoreText(em.position, scoreMissile()));

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

  // Score
  updateHighScore();
  displayScoreboard();

  // Capture the background for the new level screen
  if (newLevel) {
    tempBackgroundImage = get();
  }

  // Crosshair
  noCursor();
  imageMode(CORNER);
  image(crosshair, mouseX - crosshair.width / 28, mouseY - crosshair.height / 28, crosshair.width / 14, crosshair.width / 14);
}

// Main functions
void setup() {
  size(800, 600);

  // Fonts
  friendOrFoeTallBB = createFont("assets/fonts/FriendOrFoeTallBB/Friend or Foe Tall BB.ttf", 32);
  spaceGroteskLight = createFont("assets/fonts/SpaceGrotesk/SpaceGrotesk-Light.ttf", 32);

  // Images
  ground = loadImage("assets/images/ground.png");
  separator = loadImage("assets/images/separator.png");
  pause = loadImage("assets/images/pause.png");
  crosshair = loadImage("assets/images/crosshair.png");
  destination = loadImage("assets/images/destination.png");
  background = loadImage("assets/images/background.png");
  menuBackground = loadImage("assets/images/menu_background.png");
  gameOverBackground = loadImage("assets/images/game_over_background.png");
  enemyExplosion = loadImage("assets/images/enemy_explosion.png");
  antiMissileExplosion = loadImage("assets/images/antimissile_explosion.png");
  city = loadImage("assets/images/neon_city.png");
  destroyedCity = loadImage("assets/images/destroyed_city.png");
  base = loadImage("assets/images/base.png");
  destroyedBase = loadImage("assets/images/destroyed_base.png");

  // Sounds
  master = new Sound(this);
  menuMusic = new SoundFile(this, "assets/sounds/menu-music.wav");
  gameBackgroundMusic = new SoundFile(this, "assets/sounds/background-music-1.wav");
  gameOverSound = new SoundFile(this, "assets/sounds/game-over-sound.wav");
  buttonClickSound = new SoundFile(this, "assets/sounds/button_click.mp3");
  lazer = new SoundFile(this, "assets/sounds/powerful-laser.wav");
  startSound = new SoundFile(this, "assets/sounds/game-start-sound.wav");
  explosionSound = new SoundFile(this, "assets/sounds/explosion.wav");
  enemyExplodeSound = new SoundFile(this, "assets/sounds/enemy-explode3.wav");
  baseDestroyedSound = new SoundFile(this, "assets/sounds/base-destroyed.wav");

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
    case SCORE:
      drawScoreScreen();
      break;
  }
}

void keyPressed() {
  if (key == ESC) {
    key = 0; // Prevent default behavior
    if (currentState == GameState.PAUSE) {
      gameBackgroundMusic.amp(0.2);
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
  SoundController(startSound, 0.4, false);
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
