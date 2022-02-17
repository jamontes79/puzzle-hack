import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:puzzle/puzzle/domain/models/puzzle.dart';
import 'package:puzzle/puzzle/domain/models/tile_puzzle.dart';
import 'package:puzzle/puzzle/infrastructure/crop_image.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc(this._cropImage)
      : super(
          const PuzzleState(
            puzzle: Puzzle(
              image: '',
              tiles: [],
              size: 600,
            ),
            loading: true,
          ),
        ) {
    on<InitializePuzzle>(_onInitializePuzzle);
    on<SwapTile>(_onSwapTile);
    on<ShufflePuzzle>(_onShufflePuzzle);
    on<MoveTileWithVoiceCommand>(_onMoveTileWithVoiceCommand);
    on<EnableVoiceCommands>(_onEnableVoiceCommands);
    on<DisableVoiceCommands>(_onDisableVoiceCommand);
  }

  final CropImage _cropImage;

  int _puzzleDimensionFromLevel(final int level) {
    return level + 1;
  }

  String _puzzleImageFromLevel(final int level) {
    late String image;
    switch (level) {
      case 1:
        image = 'dart.png';
        break;
      case 2:
        image = 'caleta.png';
        break;
      case 3:
        image = 'dash.png';
        break;
    }
    return image;
  }

  Future<FutureOr<void>> _onInitializePuzzle(
    InitializePuzzle event,
    Emitter<PuzzleState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        solved: false,
      ),
    );
    final splitImageInfo = SplitImageInfo(
      _puzzleImageFromLevel(event.level),
      _puzzleDimensionFromLevel(event.level),
    );
    final imageParts = await _cropImage.splitImage(splitImageInfo);
    final puzzleConfiguration = PuzzleConfiguration(
      dimension: _puzzleDimensionFromLevel(event.level),
      imageParts: imageParts,
      size: event.size,
      image: _puzzleImageFromLevel(event.level),
    );
    final puzzleShuffle = state.puzzle.init(
      puzzleConfiguration,
    );

    emit(
      state.copyWith(
        level: event.level,
        puzzle: puzzleShuffle,
        tilesCorrect: puzzleShuffle.tilesCorrect,
        loading: false,
        currentMoves: 0,
      ),
    );
  }

  FutureOr<void> _onSwapTile(SwapTile event, Emitter<PuzzleState> emit) {
    emit(
      _moveTile(tile: event.tile),
    );
  }

  FutureOr<void> _onShufflePuzzle(
    ShufflePuzzle event,
    Emitter<PuzzleState> emit,
  ) {
    var puzzleShuffle = state.puzzle.shuffle();

    while (!puzzleShuffle.isSolvable()) {
      puzzleShuffle = state.puzzle.shuffle();
    }
    emit(
      state.copyWith(
        puzzle: puzzleShuffle,
        tilesCorrect: puzzleShuffle.tilesCorrect,
        currentMoves: 0,
        solved: puzzleShuffle.tilesCorrect == puzzleShuffle.tiles.length,
        loading: false,
      ),
    );
  }

  FutureOr<void> _onMoveTileWithVoiceCommand(
    MoveTileWithVoiceCommand event,
    Emitter<PuzzleState> emit,
  ) {
    final tile = state.puzzle.getFromStringCoordinate(event.voiceCommand);
    if (tile != null) {
      emit(
        _moveTile(
          tile: tile,
          voiceCommand: event.voiceCommand,
        ),
      );
    } else {
      emit(
        state.copyWith(
          canMakeMove: false,
          lastVoiceCommand: event.voiceCommand,
          errorVoiceCommand: true,
        ),
      );
    }
  }

  PuzzleState _moveTile({required TilePuzzle tile, String? voiceCommand}) {
    if (state.puzzle.canMove(tile)) {
      final puzzle = state.puzzle.moveTile(tile);
      return state.copyWith(
        puzzle: puzzle,
        canMakeMove: true,
        currentMoves: state.currentMoves + 1,
        tilesCorrect: puzzle.tilesCorrect,
        solved: puzzle.tilesCorrect == puzzle.tiles.length,
        lastVoiceCommand: voiceCommand ?? '',
        errorVoiceCommand: false,
      );
    } else {
      return state.copyWith(
        canMakeMove: false,
        lastVoiceCommand: voiceCommand ?? '',
        errorVoiceCommand: false,
      );
    }
  }

  FutureOr<void> _onEnableVoiceCommands(
    EnableVoiceCommands event,
    Emitter<PuzzleState> emit,
  ) {
    emit(
      state.copyWith(
        voiceCommands: true,
      ),
    );
  }

  FutureOr<void> _onDisableVoiceCommand(
    DisableVoiceCommands event,
    Emitter<PuzzleState> emit,
  ) {
    emit(
      state.copyWith(
        voiceCommands: false,
      ),
    );
  }
}
