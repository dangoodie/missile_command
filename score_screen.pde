Button nextLevelButton;
int survivingCities, bonusPointsLevel;

void setupScoreScreen() {
  // "Return to Game" button
  nextLevelButton = new Button(width/2 - 100, height/2 + 60, 200, 50, "Next Level", () -> {
    currentState = GameState.GAME;
    displayCrosshair = true;
  });
  nextLevelButton.bgColor = color(red(blue), green(blue), blue(blue));
  nextLevelButton.bgHoverColor = color(red(color(0x009acc)), green(color(0x009acc)), blue(color(0x009acc)));

  // Darken background
  fill(0, 127);
  rect(0, 0, width, height);
}

void drawScoreScreen() {

  cursor();

  fill(color(red(blue), green(blue), blue(blue)));
  textFont(spaceGroteskLight);
  textSize(15);
  textAlign(CENTER, CENTER);
  text("LVL " + bonusPointsLevel, width/2, height / 2 - 145);

  fill(255);
  textFont(friendOrFoeTallBB);
  textSize(60);
  textAlign(CENTER, CENTER);
  text("BONUS POINTS", width / 2, height / 2 - 110);

  textFont(spaceGroteskLight);
  textSize(20);
  text("Extra Munition: " + leftOverAmmo, width / 2, 240);
  text("Surviving Cities: " + survivingCities, width / 2, 270);

  imageMode(CENTER);
  image(separator, 400, 300, separator.width / 9, separator.height / 9);
  text("Score: " + score, width / 2, 330);

  nextLevelButton.display();
  nextLevelButton.checkClick();
}

int calculateBonusPoints() {
  int totalBonusPoints = 0;

  // Left over ammo
  for (int i = 0; i < leftOverAmmo; i++) {
    totalBonusPoints += 5;
  }

  // Surviving cities
  for (int i = cities.size() - 1; i >= 0; i--) {
    City c = cities.get(i);
    
    if (c.isAlive == true) {
      totalBonusPoints += 100;
      survivingCities++;
    }
  }
  
  return totalBonusPoints;
}

int getBonusPointsLevel() {
  return bonusPointsLevel += 1;
}
