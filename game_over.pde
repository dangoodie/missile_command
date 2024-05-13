Button newGameButton;
Button menuButton;

void setupGameOver() {
  // New Game button
  newGameButton = new Button(width/2 - 100, height/2 - 40, 200, 50, "New Game", () -> {   
    currentState = GameState.GAME;
    newGame();
  });
  newGameButton.bgColor = color(70, 195, 76);
  newGameButton.bgHoverColor = color(71,159,120);

  // Menu button
  menuButton = new Button(width/2 - 100, height/2 + 30, 200, 50, "Menu", () -> {
    currentState = GameState.MENU;
    setupMenu();
  });
  menuButton.bgColor = color(70,195,76);
  menuButton.bgHoverColor = color(71,159,120);
}

void drawGameOver() {
   // display game over screen
  pg.beginDraw();
  cursor();
  pg.fill(0, 100);
  pg.rect(0, 0, width, height);

  pg.fill(255);
  pg.textSize(50);
  pg.textAlign(CENTER, CENTER);
  pg.text("Game Over", width / 2, height / 2 - 150);
  pg.textSize(20);
  pg.text("Score: " + score, width / 2, height / 2 - 70);
  pg.text("High Score: " + highScore, width / 2, height / 2 - 100);
  pg.endDraw();
  // Display buttons
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