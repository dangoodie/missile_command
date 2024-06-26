Button resumeButton;
Button returnMenuButton;

void setupPause() {
  gameBackgroundMusic.amp(0.05);

  // "Resume" button
  resumeButton = new Button(width/2 - 100, height/2 - 40, 200, 50, "Resume", () -> {
    gameBackgroundMusic.amp(0.2); 
    currentState = GameState.GAME;
  });
  resumeButton.bgColor = color(red(blue), green(blue), blue(blue));
  resumeButton.bgHoverColor = color(red(color(0x009acc)), green(color(0x009acc)), blue(color(0x009acc)));

  // "Return to Menu" button
  returnMenuButton = new Button(width/2 - 100, height/2 + 30, 200, 50, "Quit To Menu", () -> {
    currentState = GameState.MENU;
    gameBackgroundMusic.stop();
    setupMenu();
  });
  returnMenuButton.bgColor = color(red(blue), green(blue), blue(blue));
  returnMenuButton.bgHoverColor = color(red(color(0x009acc)), green(color(0x009acc)), blue(color(0x009acc)));

  // Mute button
  String muteLabel = mute ? "Unmute" : "Mute";
  muteButton = new Button (width/2 - 100, height/2 + 100, 200, 50, muteLabel, () -> {
    mute();
    muteButton.label = mute ? "Unmute" : "Mute";
  });
  muteButton.bgColor = color(red(blue), green(blue), blue(blue));
  muteButton.bgHoverColor = color(red(color(0x009acc)), green(color(0x009acc)), blue(color(0x009acc)));
  
  tempBackgroundImage = get();
}

void drawPause() {
  cursor();
  
  // Background
  imageMode(CORNER);
  image(tempBackgroundImage, 0, 0);
  fill(0, 127);
  rect(0, 0, width, height);

  // Pause icon
  image(
    pause, 
    width / 2 - pause.width * 45.0 / pause.width / 2, height / 2 - pause.height * 45.0 / pause.width / 2 - 150, 
    pause.width * 45.0 / pause.width, pause.height * 45.0 / pause.width
  );

  // Text
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Score: " + score, width / 2, height / 2 - 70);
  text("High Score: " + highScore, width / 2, height / 2 - 100);

  // Buttons
  resumeButton.display();
  resumeButton.checkClick();
  returnMenuButton.display();
  returnMenuButton.checkClick();
  muteButton.display();
  muteButton.checkClick();
}
