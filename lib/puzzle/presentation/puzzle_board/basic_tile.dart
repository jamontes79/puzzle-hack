import 'package:flutter/material.dart';
import 'package:puzzle/puzzle/domain/models/tile_puzzle.dart';

class BasicTile extends StatelessWidget {
  const BasicTile({Key? key, required this.tile, required this.tileSize})
      : super(key: key);
  final TilePuzzle tile;
  final double tileSize;
  @override
  Widget build(BuildContext context) {
    return tile.imagePart == null
        ? _TitleWihoutImage(tileSize: tileSize, tile: tile)
        : _TileWithImage(tileSize: tileSize, tile: tile);
  }
}

class _TileWithImage extends StatelessWidget {
  const _TileWithImage({
    Key? key,
    required this.tileSize,
    required this.tile,
  }) : super(key: key);

  final double tileSize;
  final TilePuzzle tile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: tileSize,
      width: tileSize,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: tile.isCorrectPosition ? Colors.green : Colors.black,
        border: Border.all(
          width: tile.isCorrectPosition ? 1 : 0,
          color: tile.isCorrectPosition ? Colors.green : Colors.black,
        ),
      ),
      child: ClipRRect(
        child: Center(
          child: Image.memory(
            tile.imagePart!,
            width: tileSize,
            height: tileSize,
          ),
        ),
      ),
    );
  }
}

class _TitleWihoutImage extends StatelessWidget {
  const _TitleWihoutImage({
    Key? key,
    required this.tileSize,
    required this.tile,
  }) : super(key: key);

  final double tileSize;
  final TilePuzzle tile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.blue,
      ),
      height: tileSize,
      width: tileSize,
      child: Center(
        child: Text(
          tile.value.toString(),
          style: const TextStyle().copyWith(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
