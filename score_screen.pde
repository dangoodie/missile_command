Button nextLevelButton;
int bonusPointsLevel, survivingCities, survivingCitiesPoints, leftOverAmmoPoints;

void setupScoreScreen() {
  // "Return to Game" button
  nextLevelButton = new Button(width/2 - 100, height/2 + 60, 200, 50, "Next Level", () -> {
    currentState = GameState.GAME;
  });
  nextLevelButton.bgColor = color(red(blue), green(blue), blue(blue));
  nextLevelButton.bgHoverColor = color(red(color(0x009acc)), green(color(0x009acc)), blue(color(0x009acc)));
}

void drawScoreScreen() {
  cursor();

  // Background
  imageMode(CORNER);
  image(tempBackgroundImage, 0, 0);
  fill(0, 127);
  rect(0, 0, width, height);

  // Text
  fill(255);
  textFont(friendOrFoeTallBB);
  textSize(60);
  textAlign(CENTER, CENTER);
  text("LVL " + bonusPointsLevel, width / 2, height / 2 - 145);

  fill(color(red(blue), green(blue), blue(blue)));
  textFont(spaceGroteskLight);
  textSize(15);
  textAlign(CENTER, CENTER);
  text("BONUS POINTS", width/2, height / 2 - 110);

  fill(255);
  textFont(spaceGroteskLight);
  textSize(20);
  text("Extra Ammo: " + leftOverAmmo + " x 5 = " + leftOverAmmoPoints, width / 2, 240);
  text("Surviving Cities: " + survivingCities + " x 100 = " + survivingCitiesPoints, width / 2, 270);

  imageMode(CENTER);
  image(separator, 400, 300, separator.width / 9, separator.height / 9);
  text("Score: " + score, width / 2, 330);

  // Button
  nextLevelButton.display();
  nextLevelButton.checkClick();
}

int calculateBonusPoints() {
  // Left over ammo
  for (int i = 0; i < leftOverAmmo; i++) {
    leftOverAmmoPoints += 5;
  }

  // Surviving cities
  for (int i = cities.size() - 1; i >= 0; i--) {
    City c = cities.get(i);
    
    if (c.isAlive == true) {
      survivingCitiesPoints += 100;
      survivingCities++;
    }
  }
  
  return leftOverAmmoPoints + survivingCitiesPoints;
}

int getBonusPointsLevel() {
  return bonusPointsLevel += 1;
}
