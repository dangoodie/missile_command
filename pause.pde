Button resumeButton;
Button returnMenuButton;

void setupPause() {
  game_bground_music.amp(0.05);
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
  pg.beginDraw();
  pg.fill(0, 127);
  pg.rect(0, 0, width, height);
  pg.endDraw();
}

void drawPause() {
   // display game over screen
  pg.beginDraw();
  cursor();

  pg.fill(255);
  pg.textSize(50);
  pg.textAlign(CENTER, CENTER);
  pg.text("Pause", width / 2, height / 2 - 150);
  pg.textSize(20);
  pg.text("Score: " + score, width / 2, height / 2 - 70);
  pg.text("High Score: " + highScore, width / 2, height / 2 - 100);
  pg.endDraw();

  // Display buttons
 resumeButton.display();
  returnMenuButton.display();
 resumeButton.checkClick();
  returnMenuButton.checkClick();
}
