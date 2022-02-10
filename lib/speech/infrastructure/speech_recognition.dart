import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:puzzle/speech/domain/usecases/i_speech_recognition.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

@LazySingleton(as: ISpeechRecognition)
class SpeechRecognition implements ISpeechRecognition {
  SpeechRecognition() {
    _speechToText = SpeechToText();
  }
  final double _minimumWordConfidence = 0.5;
  late final SpeechToText _speechToText;
  Function(String)? _sendCommand;
  int _previousLastIndex = -1;
  int _depthParsedPreviousLastElement = 0;
  static bool _initialized = false;

  @override
  void stopListening() {
    if (_initialized) {
      _speechToText.stop();
      _sendCommand = null;
      _initialized = false;
    }
  }

  @override
  void initialize({required Function(String) sendCommand}) {
    if (!_initialized) {
      _initialized = true;
      _sendCommand = sendCommand;
      _speechToText.initialize().then((bool success) async {
        await _startListening();
      });
      _speechToText.statusListener = _onStatusChanged;
    }
  }

  Future<void> _startListening() {
    return _speechToText.listen(
      onResult: _onSpeechResult,
      pauseFor: const Duration(minutes: 5),
    );
  }

  void _onStatusChanged(String status) {
    // if (status == "done") {
    //   _startListening();
    // }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    // This means that a new element has appeared.
    if (result.alternates.length > _previousLastIndex) {
      _previousLastIndex = result.alternates.length;
      _depthParsedPreviousLastElement = 0;
    } else {
      // This means S2T appended to the previous `result`'s last element instead
      // of providing a new value. This usually means the S2T algorithm picked
      // up a continuous flow of speech or has refined a previous guess.
    }
    _processSpeechToTextElement(
      element: result.alternates.last,
      alreadyParsedTo: _depthParsedPreviousLastElement,
    );
  }

  void _processSpeechToTextElement({
    required SpeechRecognitionWords element,
    required int alreadyParsedTo,
  }) {
    if (element.hasConfidenceRating) {
      if (element.isConfident(threshold: _minimumWordConfidence)) {
        final newWords = element.recognizedWords
            .substring(min(element.recognizedWords.length, alreadyParsedTo));
        for (final word in newWords.split(' ')) {
          _sendCommand?.call(word);
          _depthParsedPreviousLastElement += word.length + 1;
        }
      }
    }
  }
}
