Button newGameButton;
Button menuButton;

void setupGameOver() {
  // New Game button
  newGameButton = new Button(width/2 - 100, height/2 - 50, 200, 50, "New Game", () -> {   
    currentState = GameState.GAME;
    setupGame();
  });
  newGameButton.bgColor = color(70, 195, 76);
  newGameButton.bgHoverColor = color(71,159,120);

  // Menu button
  menuButton = new Button(width/2 - 100, height/2 + 20, 200, 50, "Menu", () -> {
    exit();
  });
  menuButton.bgColor = color(70,195,76);
  menuButton.bgHoverColor = color(71,159,120);
}

void drawGameOver() {
   // display game over screen
  fill(0, 100);
  rect(0, 0, width, height);

  fill(255);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Game Over", width / 2, height / 2 - 50);
  textSize(20);
  text("Score: " + score, width / 2, height / 2);
  text("High Score: " + highScore, width / 2, height / 2 + 30);

  // Display buttons
  newGameButton.display();
  menuButton.display();
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