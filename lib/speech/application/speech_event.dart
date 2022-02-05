part of 'speech_bloc.dart';

abstract class SpeechEvent extends Equatable {
  const SpeechEvent();
}

class StartListening extends SpeechEvent {
  @override
  List<Object?> get props => [];
}

class StopListening extends SpeechEvent {
  @override
  List<Object?> get props => [];
}
