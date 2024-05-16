class ScoreText {
  int score;
  float messageAlpha = 255;
  float moveAmount = 0;
  int now;
  int duration = 1000; // Duration in milliseconds for the fade effect
  int distance = 10; // Distance to move the text up
  PVector position; // To hold the position of the text

  ScoreText(PVector position, int score) {
    this.score = score;
    this.position = position; // Set the position where the text will be displayed
    now = millis(); // Capture the time when the object is created

    if (debug) System.out.println("ScoreText created");
  }

  void display() {
    int elapsedTime = millis() - now; // Calculate elapsed time
    if (elapsedTime < duration) {
      float fadeAmount = map(elapsedTime, 0, duration, 255, 0);
      moveAmount = map(elapsedTime, 0, duration, 0, distance);
      messageAlpha = fadeAmount; // Update the alpha value based on the elapsed time
    } else {
      messageAlpha = 0; // Set alpha to 0 after the duration

    }

    if (messageAlpha > 0) { // Only display the text if alpha is greater than 0
      fill(255, 255, 255, messageAlpha); // Set fill color with dynamic alpha
      textSize(20);
      text("+" + score, position.x, position.y - moveAmount); // Display the score
    }
  }

  boolean isExpired() {
    return messageAlpha == 0;
  }
}
