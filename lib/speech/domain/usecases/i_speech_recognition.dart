abstract class ISpeechRecognition {
  void initialize({required Function(String) sendCommand});
  void stopListening();
}
