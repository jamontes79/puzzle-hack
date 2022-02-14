part of 'puzzle_bloc.dart';

class PuzzleState extends Equatable {
  const PuzzleState({
    required this.puzzle,
    this.canMakeMove = true,
    this.currentMoves = 0,
    this.tilesCorrect = 0,
    this.solved = false,
    this.loading = false,
    this.level = 1,
    this.lastVoiceCommand = '',
    this.voiceCommands = false,
    this.errorVoiceCommand = false,
  });

  final Puzzle puzzle;
  final bool canMakeMove;
  final int currentMoves;
  final int tilesCorrect;
  final bool solved;
  final bool loading;
  final int level;
  final String lastVoiceCommand;
  final bool voiceCommands;
  final bool errorVoiceCommand;
  PuzzleState copyWith({
    Puzzle? puzzle,
    bool? canMakeMove,
    int? currentMoves,
    int? tilesCorrect,
    bool? solved,
    bool? loading,
    int? level,
    String? lastVoiceCommand,
    bool? voiceCommands,
    bool? errorVoiceCommand,
  }) {
    return PuzzleState(
      puzzle: puzzle ?? this.puzzle,
      canMakeMove: canMakeMove ?? this.canMakeMove,
      currentMoves: currentMoves ?? this.currentMoves,
      tilesCorrect: tilesCorrect ?? this.tilesCorrect,
      solved: solved ?? this.solved,
      loading: loading ?? this.loading,
      level: level ?? this.level,
      lastVoiceCommand: lastVoiceCommand ?? this.lastVoiceCommand,
      voiceCommands: voiceCommands ?? this.voiceCommands,
      errorVoiceCommand: errorVoiceCommand ?? this.errorVoiceCommand,
    );
  }

  @override
  List<Object> get props => [
        puzzle,
        canMakeMove,
        currentMoves,
        tilesCorrect,
        solved,
        loading,
        level,
        lastVoiceCommand,
        voiceCommands,
        errorVoiceCommand,
      ];
}
