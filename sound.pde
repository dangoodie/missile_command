void SoundController(SoundFile sound, float volume, boolean loop) {
  if (sound.isPlaying()) {
    sound.stop();
  }
  if (loop == true) {
    sound.loop();
    sound.amp(volume);
  }
  if (loop == false) {
    sound.play();
    sound.amp(volume);
  }
}
