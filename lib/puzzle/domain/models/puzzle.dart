import 'dart:math';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:puzzle/extensions/list_extension.dart';
import 'package:puzzle/puzzle/domain/models/position.dart';
import 'package:puzzle/puzzle/domain/models/tile_puzzle.dart';

class Puzzle extends Equatable {
  const Puzzle({
    required this.image,
    required this.tiles,
    this.tilesCorrect = 0,
    required this.size,
  });

  final List<TilePuzzle> tiles;
  final int tilesCorrect;
  final double size;
  final String image;
  static const alphabet = {
    'A': 0,
    'B': 1,
    'C': 2,
    'D': 3,
    'E': 4,
    'F': 5,
    'G': 6,
    'H': 7,
    'I': 8,
    'J': 9,
    'K': 10,
    'L': 11,
    'M': 12,
    'N': 13,
    'O': 14,
    'P': 15,
    'Q': 16,
    'R': 17,
    'S': 18,
    'T': 19,
    'U': 20,
    'V': 21,
    'W': 22,
    'X': 23,
    'Y': 24,
    'Z': 25,
  };
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
    required String image,
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
      image: image,
    );
  }

  Puzzle copyWith({
    List<TilePuzzle>? tiles,
    int? tilesCorrect,
    double? size,
    String? image,
  }) {
    return Puzzle(
      image: image ?? this.image,
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

  TilePuzzle? getFromStringCoordinate(String coordinate) {
    if (coordinate.length > 1) {
      final xChar = coordinate.substring(1);
      final yChar = coordinate.substring(0, 1);
      final x = alphabet[yChar];
      final y = int.tryParse(xChar);

      if (x != null && y != null) {
        final findPosition = Position(x: x, y: y - 1);
        try {
          final tile = tiles.firstWhere(
            (element) => element.currentPosition == findPosition,
          );
          return tile;
        } on Error catch (_) {
          return null;
        }
      }
    }
    return null;
  }
}
