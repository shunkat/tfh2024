import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioAppeal {
  AudioPlayer? _audioPlayer;
  bool _isInitialized = false;

  static final AudioAppeal _instance = AudioAppeal._internal();

  factory AudioAppeal() {
    return _instance;
  }

  AudioAppeal._internal();

  Future<void> initialize(int value) async {
    if (!_isInitialized) {
      _audioPlayer = AudioPlayer();
      _isInitialized = true;
    }

    try {
      debugPrint('Loading sound${value + 1}.mp3');
      // アセットパスを修正
      await _audioPlayer?.setAsset('assets/sound/sound${value + 1}.mp3');
      await _audioPlayer?.play();
    } catch (e) {
      debugPrint('Error loading audio: $e');
      rethrow;
    }
  }

  void play() {
    _audioPlayer?.play();
  }

  void pause() {
    _audioPlayer?.pause();
  }

  void dispose() {
    _audioPlayer?.dispose();
    _audioPlayer = null;
    _isInitialized = false;
  }

  Stream<bool>? get playingStream => _audioPlayer?.playingStream;
  bool get isPlaying => _audioPlayer?.playing ?? false;
}
