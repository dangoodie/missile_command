Button newGameButton;
Button menuButton;

void setupGameOver() {
  game_bground_music.stop();
  SoundController(game_over_sound, 0.4, false);
  
  // "New Game" button
  newGameButton = new Button(width/2 - 100, height/2 - 40, 200, 50, "New Game", () -> {   
    currentState = GameState.GAME;
    newGame();
  });
  newGameButton.bgColor = color(red(blue), green(blue), blue(blue));
  newGameButton.bgHoverColor = color(red(color(0x009acc)), green(color(0x009acc)), blue(color(0x009acc)));

  // "Menu" button
  menuButton = new Button(width/2 - 100, height/2 + 30, 200, 50, "Menu", () -> {
    currentState = GameState.MENU;
    setupMenu();
  });
  menuButton.bgColor = color(red(blue), green(blue), blue(blue));
  menuButton.bgHoverColor = color(red(color(0x009acc)), green(color(0x009acc)), blue(color(0x009acc)));
}

void drawGameOver() {
  // "Game over" screen
  background(gameOverBackground);
  cursor();
  fill(0, 100);
  rect(0, 0, width, height);

  fill(255);
  textFont(friendOrFoeTallBB);
  textSize(70);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width / 2, height / 2 - 150);

  textFont(spaceGroteskLight);
  textSize(18);
  text("Score: " + score, width / 2, 200);
  text("High Score: " + highScore, width / 2, 220);

  // Buttons
  newGameButton.display();
  menuButton.display();
  newGameButton.checkClick();
  menuButton.checkClick();
}

// Game over helper functions
boolean checkGameOver() {
  for (City city : cities) {
    if (city.isAlive()) {
      return false;
    }
  }
  return true;
}
