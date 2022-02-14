part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();
}

class InitializePuzzle extends PuzzleEvent {
  const InitializePuzzle({
    required this.level,
    required this.size,
  });

  final int level;
  final double size;

  @override
  List<Object?> get props => [
        level,
        size,
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

class MoveTileWithVoiceCommand extends PuzzleEvent {
  const MoveTileWithVoiceCommand(this.voiceCommand);

  final String voiceCommand;

  @override
  List<Object?> get props => [voiceCommand];
}

class EnableVoiceCommands extends PuzzleEvent {
  const EnableVoiceCommands();

  @override
  List<Object?> get props => [];
}

class DisableVoiceCommands extends PuzzleEvent {
  const DisableVoiceCommands();

  @override
  List<Object?> get props => [];
}
