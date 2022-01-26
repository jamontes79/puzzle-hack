part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();
}

class InitializePuzzle extends PuzzleEvent {
  const InitializePuzzle({
    required this.level,
    required this.image,
    required this.size,
  });

  final int level;
  final double size;
  final String image;
  @override
  List<Object?> get props => [
        level,
        size,
        image,
      ];
}

class SwapTile extends PuzzleEvent {
  const SwapTile(this.tile);

  final TilePuzzle tile;

  @override
  List<Object?> get props => [tile];
}

class ShufflePuzzle extends PuzzleEvent {
  const ShufflePuzzle();

  @override
  List<Object?> get props => [];
}
