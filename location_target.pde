class LocationTarget implements Target {
  PVector position;

  LocationTarget(PVector position) {
    this.position = position;
  }

  void display() {
    // Uncomment when you have a destination image
    pg.beginDraw();
    pg.image(destination, position.x - destination.width / 224, position.y - destination.height / 224, destination.width / 112, destination.width / 112);
    pg.endDraw();
  }

  PVector getPosition() {
    // Return the position of the target
    return this.position;
  }
}