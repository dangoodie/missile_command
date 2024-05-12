Button resumeButton;
Button returnMenuButton;

void setupPause() {
  // Resume
  resumeButton = new Button(width/2 - 100, height/2 - 40, 200, 50, "Resume", () -> {   
    currentState = GameState.GAME;
  });
  resumeButton.bgColor = color(70, 195, 76);
  resumeButton.bgHoverColor = color(71,159,120);

  // Return to Menu button
  returnMenuButton = new Button(width/2 - 100, height/2 + 30, 200, 50, "Quit To Menu", () -> {
    currentState = GameState.MENU;
    setupMenu();
  });
  returnMenuButton.bgColor = color(70,195,76);
  returnMenuButton.bgHoverColor = color(71,159,120);
  
  // darken background
  fill(0, 127);
  rect(0, 0, width, height);
}

void drawPause() {
   // display game over screen
  cursor();

  fill(255);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Pause", width / 2, height / 2 - 150);
  textSize(20);
  text("Score: " + score, width / 2, height / 2 - 70);
  text("High Score: " + highScore, width / 2, height / 2 - 100);

  // Display buttons
 resumeButton.display();
  returnMenuButton.display();
 resumeButton.checkClick();
  returnMenuButton.checkClick();
}