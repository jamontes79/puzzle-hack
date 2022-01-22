import 'dart:math';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:puzzle/extensions/list_extension.dart';
import 'package:puzzle/puzzle/domain/models/position.dart';
import 'package:puzzle/puzzle/domain/models/tile_puzzle.dart';

class Puzzle extends Equatable {
  const Puzzle({
    required this.tiles,
    this.tilesCorrect = 0,
    required this.size,
  });

  final List<TilePuzzle> tiles;
  final int tilesCorrect;
  final double size;
  Puzzle shuffle() {
    final dimension = getDimension();
    final shuffledTiles = <TilePuzzle>[];

    tiles.shuffle(Random());
    final whiteTileIndex = tiles.indexWhere((tile) => tile.isWhite);
    final whiteTile = tiles[whiteTileIndex].copyWith(
      currentPosition: Position.fromListPosition(
        dimension: dimension,
        positionInList: whiteTileIndex,
      ),
    );

    for (var i = 0; i < tiles.length; i++) {
      final newPosition = Position.fromListPosition(
        dimension: dimension,
        positionInList: i,
      );
      final tileUpdatedWithPosition = tiles[i].copyWith(
        currentPosition: tiles[i].currentPosition.replaceWith(
              x: newPosition.x,
              y: newPosition.y,
            ),
      );
      final tileUpdatedWithCanMove = tileUpdatedWithPosition.copyWith(
        canMove: tileUpdatedWithPosition.isAdjacentTo(whiteTile),
      );
      shuffledTiles.add(
        tileUpdatedWithCanMove,
      );
    }
    final numberOfTilesCorrect = shuffledTiles.where(
      (element) => element.currentPosition == element.correctPosition,
    );
    return copyWith(
      tiles: shuffledTiles,
      tilesCorrect: numberOfTilesCorrect.length,
    );
  }

  int getDimension() {
    return sqrt(tiles.length).toInt();
  }

  Puzzle init({
    required int dimension,
    required List<Uint8List> imageParts,
    required double size,
  }) {
    final tiles = <TilePuzzle>[];
    for (var i = 0; i < dimension; i++) {
      for (var j = 0; j < dimension; j++) {
        tiles.add(
          TilePuzzle(
            currentPosition: Position(x: i, y: j),
            correctPosition: Position(x: i, y: j),
            isWhite: (i == dimension - 1) && (j == dimension - 1),
            canMove: false,
            value: tiles.length + 1,
            imagePart: imageParts.length > tiles.length
                ? imageParts[tiles.length]
                : null,
            size: size / dimension,
          ),
        );
      }
    }
    final numberOfTilesCorrect = tiles.where(
      (element) => element.currentPosition == element.correctPosition,
    );
    return copyWith(
      tiles: tiles,
      tilesCorrect: numberOfTilesCorrect.length,
    );
  }

  Puzzle copyWith({
    List<TilePuzzle>? tiles,
    int? tilesCorrect,
    double? size,
  }) {
    return Puzzle(
      tiles: tiles ?? this.tiles,
      tilesCorrect: tilesCorrect ?? this.tilesCorrect,
      size: size ?? this.size,
    );
  }

  Puzzle moveTile(TilePuzzle movedTile) {
    final dimension = getDimension();
    final currentTileIndex = tiles.indexWhere(
      (tile) => tile.currentPosition == movedTile.currentPosition,
    );

    final whiteTileIndex = tiles.indexWhere((tile) => tile.isWhite);

    tiles.swap(currentTileIndex, whiteTileIndex);

    final whiteTile = tiles[currentTileIndex].copyWith(
      currentPosition: Position.fromListPosition(
        dimension: dimension,
        positionInList: currentTileIndex,
      ),
    );
    final exchangedTiles = <TilePuzzle>[];

    for (var i = 0; i < tiles.length; i++) {
      final newPosition = Position.fromListPosition(
        dimension: dimension,
        positionInList: i,
      );
      final tileUpdatedWithPosition = tiles[i].copyWith(
        currentPosition: tiles[i].currentPosition.replaceWith(
              x: newPosition.x,
              y: newPosition.y,
            ),
      );
      final tileUpdatedWithCanMove = tileUpdatedWithPosition.copyWith(
        canMove: tileUpdatedWithPosition.isAdjacentTo(whiteTile),
      );

      exchangedTiles.add(
        tileUpdatedWithCanMove,
      );
    }
    final numberOfTilesCorrect = exchangedTiles.where(
      (element) => element.currentPosition == element.correctPosition,
    );
    return copyWith(
      tiles: exchangedTiles,
      tilesCorrect: numberOfTilesCorrect.length,
    );
  }

  @override
  List<Object?> get props => [
        tiles,
      ];

  bool canMove(TilePuzzle tilePuzzle) {
    final whiteTile = tiles.firstWhere((tile) => tile.isWhite);
    return tilePuzzle.isAdjacentTo(whiteTile);
  }

  /// Determines if the puzzle is solvable.
  bool isSolvable() {
    final size = getDimension();
    if (size == 0) {
      return false;
    }
    final height = tiles.length ~/ size;
    assert(
      size * height == tiles.length,
      'tiles must be equal to size * height',
    );
    final inversions = countInversions();

    if (size.isOdd) {
      return inversions.isEven;
    }

    final whitespace = tiles.singleWhere((tile) => tile.isWhite);
    final whitespaceRow = whitespace.currentPosition.y;

    if (((height - whitespaceRow) + 1).isOdd) {
      return inversions.isEven;
    } else {
      return inversions.isOdd;
    }
  }

  /// Gives the number of inversions in a puzzle given its tile arrangement.
  ///
  /// An inversion is when a tile of a lower value is in a greater position than
  /// a tile of a higher value.
  int countInversions() {
    var count = 0;
    for (var a = 0; a < tiles.length; a++) {
      final tileA = tiles[a];
      if (tileA.isWhite) {
        continue;
      }

      for (var b = a + 1; b < tiles.length; b++) {
        final tileB = tiles[b];
        if (_isInversion(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Determines if the two tiles are inverted.
  bool _isInversion(TilePuzzle a, TilePuzzle b) {
    if (!b.isWhite && a.value != b.value) {
      if (b.value < a.value) {
        return b.currentPosition.compareTo(a.currentPosition) > 0;
      } else {
        return a.currentPosition.compareTo(b.currentPosition) > 0;
      }
    }
    return false;
  }
}
