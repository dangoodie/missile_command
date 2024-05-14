class LocationTarget implements Target {
  PVector position;

  LocationTarget(PVector position) {
    this.position = position;
  }

  void display() {
    image(destination, position.x - destination.width / 80, position.y - destination.height / 80, destination.width / 40, destination.width / 40);
  }

  PVector getPosition() {
    // Return the position of the target
    return this.position;
  }
}
