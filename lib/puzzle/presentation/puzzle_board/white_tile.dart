import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/puzzle/application/bloc/puzzle_bloc.dart';
import 'package:puzzle/puzzle/domain/models/tile_puzzle.dart';

class WhiteTile extends StatelessWidget {
  const WhiteTile({Key? key, required this.tile, required this.tileSize})
      : super(key: key);
  final TilePuzzle tile;
  final double tileSize;
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: tile.isCorrectPosition ? 1 : 0,
              color: tile.isCorrectPosition ? Colors.green : Colors.black,
            ),
            color: Colors.white,
          ),
          width: tileSize,
          height: tileSize,
        );
      },
      onAccept: (TilePuzzle data) {
        context.read<PuzzleBloc>().add(
              SwapTile(data),
            );
      },
    );
  }
}
