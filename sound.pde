void SoundController(SoundFile sound, float volume) {
  if (sound.isPlaying()) {
    sound.stop();
  }
  sound.play();
  lazer.amp(volume);
}
