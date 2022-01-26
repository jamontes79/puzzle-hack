import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/helpers/puzzle_size.dart';
import 'package:puzzle/puzzle/application/bloc/puzzle_bloc.dart';
import 'package:puzzle/puzzle/presentation/puzzle_board/puzzle_board.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/dash_logo.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/loading_puzzle.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/puzzle_header.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/suffle_button.dart';

class PuzzleViewNormalScreen extends StatelessWidget {
  const PuzzleViewNormalScreen({Key? key, required this.image})
      : super(key: key);
  final String image;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PuzzleBloc, PuzzleState>(
      builder: (context, state) {
        if (state.loading) {
          return const LoadingPuzzle();
        } else {
          return Column(
            children: [
              PuzzleHeader(level: state.level),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      PuzzleBoard(
                        puzzle: state.puzzle,
                      ),
                      Visibility(
                        visible: state.solved,
                        child: Container(
                          color: Colors.white70,
                          width: PuzzleSizes.getBoardSize(context),
                          height: PuzzleSizes.getBoardSize(context),
                          child: Center(
                            child: Text(
                              'Congratulations!!\nNext level is coming...',
                              textAlign: TextAlign.center,
                              style: const TextStyle().copyWith(
                                fontSize: 24,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Wrap(
                        direction: Axis.vertical,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Number of movements: ${state.currentMoves}\n'
                                'Tiles Correct: ${state.tilesCorrect}',
                                style: const TextStyle().copyWith(
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: state.solved,
                                child: Text(
                                  'Solved',
                                  style: const TextStyle().copyWith(
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Image.asset(
                                'assets/puzzles/$image',
                                width: 200,
                                height: 200,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const ShuffleButton(),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const DashLogo(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
