import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechData {
  bool status;
  String text, error;
}

class SpeechRecognizer {
  static SpeechRecognizer _instance = SpeechRecognizer._init();
  static SpeechRecognizer get instance => _instance;

  final _data = SpeechData();
  final _speech = SpeechToText();
  final _speechController = StreamController<SpeechData>.broadcast();

  LocaleName language;

  factory SpeechRecognizer() => _instance;

  SpeechData get data => _data;
  Stream<SpeechData> get dataStream => _speechController.stream;
  Function(SpeechData) get dataSink => _speechController.sink.add;

  SpeechRecognizer._init() {
    _speech
        .initialize(onError: _errorListener, onStatus: _statusListener)
        .then((active) {
      if (active) _speech.systemLocale().then((locale) => language = locale);
    });
  }

  speechToText() {
    _speech
        .initialize(onStatus: _statusListener, onError: _errorListener)
        .then((avalaible) {
      if (avalaible)
        _speech.listen(onResult: _resultListener, localeId: language.localeId);
    });
    // some time later...
    _speech.stop();
  }

  _resultListener(SpeechRecognitionResult result) {
    _data.text = result.recognizedWords;
    dataSink(_data);
  }

  _errorListener(SpeechRecognitionError error) {
    _data.error = error.errorMsg;
    dataSink(_data);
  }

  _statusListener(String status) {
    _data.status = status == "listening";
    dataSink(_data);
  }

  dispose() => _speechController?.close();
}

class VoiceReader {
  static VoiceReader _instance = VoiceReader._init();
  static VoiceReader get instance => _instance;

  final FlutterTts _tts = FlutterTts();

  String _language = 'es-ES';
  double _volume = .5, _pitch = 1, _rate = .9;

  factory VoiceReader() => _instance;

  VoiceReader._init() {
    _tts.setPitch(_pitch);
    _tts.setVolume(_volume);
    _tts.setSpeechRate(_rate);
    _tts.setLanguage(_language);
  }

  speak(String text) => _tts.speak(text).then((result) => print(result));

  stop() => _tts.stop().then((result) => print(result));

  dispose() => _tts.stop();
}
