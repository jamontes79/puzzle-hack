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
          ),
        ) {
    on<InitializePuzzle>(_onInitializePuzzle);
    on<SwapTile>(_onSwapTile);
    on<ShufflePuzzle>(_onShufflePuzzle);
    on<MoveTile>(_onMoveTile);
  }

  final CropImage _cropImage;
  int _puzzleDimensionFromLevel(final int level) {
    return level + 1;
  }

  String _puzzleImageFromLevel(final int level) {
    late String image;
    switch (level) {
      case 1:
        image = 'caleta.png';
        break;
      case 2:
        image = 'dart.png';
        break;
      case 3:
        image = 'dash2.png';
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
        level: event.level,
        solved: false,
      ),
    );
    final imageParts = await _cropImage.splitImage(
      assetName: _puzzleImageFromLevel(event.level),
      pieceCount: _puzzleDimensionFromLevel(event.level),
    );
    final puzzle = state.puzzle.init(
      dimension: _puzzleDimensionFromLevel(event.level),
      imageParts: imageParts,
      size: event.size,
      image: _puzzleImageFromLevel(event.level),
    );
    var puzzleShuffle = puzzle.shuffle();
    while (!puzzleShuffle.isSolvable() &&
        puzzleShuffle.tilesCorrect == puzzleShuffle.tiles.length) {
      puzzleShuffle = puzzle.shuffle();
    }
    emit(
      state.copyWith(
        puzzle: puzzleShuffle,
        tilesCorrect: puzzleShuffle.tilesCorrect,
        loading: false,
        currentMoves: 0,
      ),
    );
  }

  FutureOr<void> _onSwapTile(SwapTile event, Emitter<PuzzleState> emit) {
    emit(
      _moveTile(event.tile),
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

  FutureOr<void> _onMoveTile(
    MoveTile event,
    Emitter<PuzzleState> emit,
  ) {
    final tile = state.puzzle.getFromStringCoordinate(event.coordinate);
    if (tile != null) {
      emit(
        _moveTile(tile),
      );
    } else {
      emit(
        state.copyWith(
          canMakeMove: false,
        ),
      );
    }
  }

  PuzzleState _moveTile(TilePuzzle tile) {
    if (state.puzzle.canMove(tile)) {
      final puzzle = state.puzzle.moveTile(tile);
      return state.copyWith(
        puzzle: puzzle,
        canMakeMove: true,
        currentMoves: state.currentMoves + 1,
        tilesCorrect: puzzle.tilesCorrect,
        solved: puzzle.tilesCorrect == puzzle.tiles.length,
      );
    } else {
      return state.copyWith(
        canMakeMove: false,
      );
    }
  }
}
