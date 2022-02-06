import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/helpers/puzzle_size.dart';
import 'package:puzzle/puzzle/application/bloc/puzzle_bloc.dart';
import 'package:puzzle/puzzle/domain/models/puzzle.dart';
import 'package:puzzle/puzzle/presentation/puzzle_board/basic_tile.dart';
import 'package:puzzle/puzzle/presentation/puzzle_board/movable_tile.dart';
import 'package:puzzle/puzzle/presentation/puzzle_board/white_tile.dart';
import 'package:puzzle/speech/infrastructure/speech_recognition.dart';

class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({
    Key? key,
    required this.puzzle,
    required this.speechRecognition,
  }) : super(key: key);

  final Puzzle puzzle;
  final SpeechRecognition speechRecognition;
  int _getPositionInList(int dimension, int x, int y) => (dimension * x) + y;

  @override
  Widget build(BuildContext context) {
    speechRecognition.initialize(
      sendCommand: (word) {
        context.read<PuzzleBloc>().add(
              MoveTile(word),
            );
      },
    );

    final dimension = puzzle.getDimension();
    final boardSize = PuzzleSizes.getBoardSize(context);
    final tileSize = PuzzleSizes.getTileSize(
      context,
      dimension,
    );
    return SizedBox(
      width: boardSize,
      height: boardSize,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                for (var x = 0; x < dimension; x++)
                  SizedBox(
                    width: tileSize,
                    child: Center(
                      child: Text(
                        Puzzle.alphabet.keys.firstWhere(
                          (k) => Puzzle.alphabet[k] == x,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            for (var x = 0; x < dimension; x++)
              Row(
                children: [
                  SizedBox(
                    height: tileSize,
                    child: Center(
                      child: Text(
                        (x + 1).toString(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
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
