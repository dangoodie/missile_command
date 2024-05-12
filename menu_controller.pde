import processing.sound.*;

Button startButton;
Button quitButton;
SoundFile menu_music;

void setupMenu() {
  // Start button
  startButton = new Button(width/2 - 100, height/2 - 50, 200, 50, "Start", () -> {   
    currentState = GameState.GAME;
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
  
  menu_music = new SoundFile(this, "menu-music.wav");
  
  SoundController(menu_music, 0.1);
}

void drawMenu() {
  background(0);
  cursor();

  fill(255);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Missile Command", width/2, height/2 - 150);

  // highScore
  textSize(20);
  text("High Score: " + highScore, width/2, height/2 - 100);
  
  startButton.display();
  quitButton.display();
  startButton.checkClick();
  quitButton.checkClick();
}
