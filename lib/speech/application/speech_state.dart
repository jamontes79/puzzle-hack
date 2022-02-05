part of 'speech_bloc.dart';

class SpeechState extends Equatable {
  const SpeechState({
    required this.coordinate,
    required this.listening,
  });
  final String coordinate;
  final bool listening;
  SpeechState copyWith({
    String? coordinate,
    bool? listening,
  }) {
    return SpeechState(
      coordinate: coordinate ?? this.coordinate,
      listening: listening ?? this.listening,
    );
  }

  @override
  List<Object?> get props => [coordinate];
}
