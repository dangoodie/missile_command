Button startButton;
Button quitButton;
Button muteButton;

void setupMenu() {
  // Start button
  startButton = new Button(width/2 - 100, 330, 200, 50, "Start", () -> {   
    currentState = GameState.GAME;
    bonusPointsLevel = 0;
    menu_music.stop();
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

  // Mute button
  String muteLabel = mute ? "Unmute" : "Mute";
  muteButton = new Button (width/2 - 100, 450, 200, 50, muteLabel, () -> {
    mute();
    muteButton.label = mute ? "Unmute" : "Mute";
  });
  muteButton.bgColor = color(red(blue), green(blue), blue(blue));
  muteButton.bgHoverColor = color(red(color(0x009acc)), green(color(0x009acc)), blue(color(0x009acc)));
  
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
  startButton.checkClick();
  quitButton.display();
  quitButton.checkClick();
  muteButton.display();
  muteButton.checkClick();
}
