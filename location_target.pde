class LocationTarget implements Target {
  PVector position;

  LocationTarget(PVector position) {
    this.position = position;
  }

  void display() {
    // Uncomment when you have a destination image
    //image(destination, position.x - destination.width / 224, position.y - destination.height / 224, destination.width / 112, destination.width / 112);

    // Remove the following lines when you have a destination image
    // Draw a circle at the target location
    fill(255, 0, 0);
    ellipse(position.x, position.y, 10, 10);

  }

  PVector getPosition() {
    // Return the position of the target
    return this.position;
  }
}