import 'package:flutter/material.dart';
import 'package:puzzle/puzzle/domain/models/tile_puzzle.dart';
import 'package:puzzle/puzzle/presentation/puzzle_board/basic_tile.dart';

class MovableTile extends StatelessWidget {
  const MovableTile({Key? key, required this.tile, required this.tileSize})
      : super(key: key);
  final TilePuzzle tile;
  final double tileSize;
  @override
  Widget build(BuildContext context) {
    return Draggable<TilePuzzle>(
      data: tile,
      feedback: Material(
        child: BasicTile(
          tile: tile,
          tileSize: tileSize,
        ),
      ),
      childWhenDragging: Container(
        height: tileSize,
        width: tileSize,
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.white,
        ),
        child: Container(),
      ),
      child: BasicTile(
        tile: tile,
        tileSize: tileSize,
      ),
    );
  }
}
