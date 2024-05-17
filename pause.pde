Button resumeButton;
Button returnMenuButton;

void setupPause() {
  game_bground_music.amp(0.05);

  // "Resume" button
  resumeButton = new Button(width/2 - 100, height/2 - 40, 200, 50, "Resume", () -> {
    game_bground_music.amp(0.2); 
    currentState = GameState.GAME;
  });
  resumeButton.bgColor = color(red(blue), green(blue), blue(blue));
  resumeButton.bgHoverColor = color(red(color(0x009acc)), green(color(0x009acc)), blue(color(0x009acc)));

  // "Return to Menu" button
  returnMenuButton = new Button(width/2 - 100, height/2 + 30, 200, 50, "Quit To Menu", () -> {
    currentState = GameState.MENU;
    game_bground_music.stop();
    setupMenu();
  });
  returnMenuButton.bgColor = color(red(blue), green(blue), blue(blue));
  returnMenuButton.bgHoverColor = color(red(color(0x009acc)), green(color(0x009acc)), blue(color(0x009acc)));
  
  // Darken background
  fill(0, 127);
  rect(0, 0, width, height);
}

void drawPause() {
  // Pause screen
  cursor();
  image(
    pause, 
    width / 2 - pause.width * 45.0 / pause.width / 2, height / 2 - pause.height * 45.0 / pause.width / 2 - 150, 
    pause.width * 45.0 / pause.width, pause.height * 45.0 / pause.width
  );
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Score: " + score, width / 2, height / 2 - 70);
  text("High Score: " + highScore, width / 2, height / 2 - 100);

  // Buttons
  resumeButton.display();
  returnMenuButton.display();
  resumeButton.checkClick();
  returnMenuButton.checkClick();
}
