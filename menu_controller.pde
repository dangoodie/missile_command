// Menu code

Button startButton;
Button quitButton;

void setupMenu() {
  // Define buttons with actions
  startButton = new Button(width/2 - 100, height/2 - 50, 200, 50, "Start", () -> {   
    currentState = GameState.GAME;
    setupGame();
    });
  startButton.bgColor = color(70, 195, 76);
  startButton.bgHoverColor = color(71,159,120);
  quitButton = new Button(width/2 - 100, height/2 + 20, 200, 50, "Quit", () -> {
    exit();
  });
  quitButton.bgColor = color(70,195,76);
  quitButton.bgHoverColor = color(71,159,120);
}

void drawMenu() {
  background(0);
  startButton.display();
  quitButton.display();
  startButton.checkClick();
  quitButton.checkClick();
}
