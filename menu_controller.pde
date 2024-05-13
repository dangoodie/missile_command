import processing.sound.*;

Button startButton;
Button quitButton;

void setupMenu() {

  
  // Start button
  startButton = new Button(width/2 - 100, height/2 - 50, 200, 50, "Start", () -> {   
    currentState = GameState.GAME;
    menu_music.stop();
    SoundController(start_sound, 0.4, false);
    newGame();
  });
  startButton.bgColor = color(70, 195, 76);
  startButton.bgHoverColor = color(71,159,120);

  // Quit button
  quitButton = new Button(width/2 - 100, height/2 + 20, 200, 50, "Quit", () -> {
    exit();
  });
  quitButton.bgColor = color(70,195,76);
  quitButton.bgHoverColor = color(71,159,120);
  
  SoundController(menu_music, 0.1, true);
}

void drawMenu() {
  pg.beginDraw();
  pg.background(0);
  cursor();

  pg.fill(255);
  pg.textSize(50);
  pg.textAlign(CENTER, CENTER);
  pg.text("Missile Command", width/2, height/2 - 150);

  // highScore
  pg.textSize(20);
  pg.text("High Score: " + highScore, width/2, height/2 - 100);
  
  pg.endDraw();
  startButton.display();
  quitButton.display();
  startButton.checkClick();
  quitButton.checkClick();
}
