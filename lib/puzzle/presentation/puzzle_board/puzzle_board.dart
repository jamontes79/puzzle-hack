import 'package:flutter/material.dart';
import 'package:puzzle/puzzle/domain/models/puzzle.dart';
import 'package:puzzle/puzzle/presentation/puzzle_board/basic_tile.dart';
import 'package:puzzle/puzzle/presentation/puzzle_board/movable_tile.dart';
import 'package:puzzle/puzzle/presentation/puzzle_board/white_tile.dart';

class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({
    Key? key,
    required this.puzzle,
    required this.boardSize,
    required this.tileSize,
  }) : super(key: key);
  final double boardSize;
  final double tileSize;
  final Puzzle puzzle;
  int _getPositionInList(int dimension, int x, int y) => (dimension * x) + y;
  @override
  Widget build(BuildContext context) {
    final dimension = puzzle.getDimension();
    return SizedBox(
      width: boardSize,
      height: boardSize,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            for (var x = 0; x < dimension; x++)
              Row(
                children: [
                  for (var y = 0; y < dimension; y++)
                    puzzle.tiles[_getPositionInList(dimension, x, y)].isWhite
                        ? WhiteTile(
                            tile: puzzle
                                .tiles[_getPositionInList(dimension, x, y)],
                            tileSize: tileSize,
                          )
                        : puzzle.tiles[_getPositionInList(dimension, x, y)]
                                .canMove
                            ? MovableTile(
                                tile: puzzle.tiles[_getPositionInList(
                                  dimension,
                                  x,
                                  y,
                                )],
                                tileSize: tileSize,
                              )
                            : BasicTile(
                                tile: puzzle.tiles[_getPositionInList(
                                  dimension,
                                  x,
                                  y,
                                )],
                                tileSize: tileSize,
                              ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
