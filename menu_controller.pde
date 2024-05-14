Button startButton;
Button quitButton;

void setupMenu() {
  // Start button
  startButton = new Button(width/2 - 100, 330, 200, 50, "Start", () -> {   
    currentState = GameState.GAME;
    menu_music.stop();
    SoundController(start_sound, 0.4, false);
    newGame();
  });
  startButton.bgColor = color(red(blue), green(blue), blue(blue));
  startButton.bgHoverColor = color(red(color(0x009acc)), green(color(0x009acc)), blue(color(0x009acc)));

  // Quit button
  quitButton = new Button(width/2 - 100, 390, 200, 50, "Quit", () -> {
    exit();
  });
  quitButton.bgColor = color(red(blue), green(blue), blue(blue));
  quitButton.bgHoverColor = color(red(color(0x009acc)), green(color(0x009acc)), blue(color(0x009acc)));
  
  SoundController(menu_music, 0.1, true);
}

void drawMenu() {
  background(menuBackground);
  cursor();

  // High Score
  fill(255);
  textFont(spaceGroteskLight);
  textSize(15);
  text("High Score: " + highScore, width/2, 300);
  
  // Buttons
  startButton.display();
  quitButton.display();
  startButton.checkClick();
  quitButton.checkClick();
}
