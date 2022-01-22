part of 'puzzle_bloc.dart';

class PuzzleState extends Equatable {
  const PuzzleState({
    required this.puzzle,
    this.canMakeMove = true,
    this.currentMoves = 0,
    this.tilesCorrect = 0,
    this.solved = false,
    this.loading = false,
  });

  final Puzzle puzzle;
  final bool canMakeMove;
  final int currentMoves;
  final int tilesCorrect;
  final bool solved;
  final bool loading;
  PuzzleState copyWith({
    Puzzle? puzzle,
    bool? canMakeMove,
    int? currentMoves,
    int? tilesCorrect,
    bool? solved,
    bool? loading,
  }) {
    return PuzzleState(
      puzzle: puzzle ?? this.puzzle,
      canMakeMove: canMakeMove ?? this.canMakeMove,
      currentMoves: currentMoves ?? this.currentMoves,
      tilesCorrect: tilesCorrect ?? this.tilesCorrect,
      solved: solved ?? this.solved,
      loading: loading ?? this.loading,
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
      ];
}
