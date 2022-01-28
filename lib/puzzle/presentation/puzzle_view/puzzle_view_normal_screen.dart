import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/puzzle/application/bloc/puzzle_bloc.dart';
import 'package:puzzle/puzzle/presentation/puzzle_board/puzzle_board.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/dash_logo.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/loading_puzzle.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/puzzle_header.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/suffle_button.dart';

class PuzzleViewNormalScreen extends StatelessWidget {
  const PuzzleViewNormalScreen({Key? key}) : super(key: key);

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
                  PuzzleBoard(
                    puzzle: state.puzzle,
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
                              const SizedBox(
                                height: 10,
                              ),
                              Image.asset(
                                'assets/puzzles/${state.puzzle.image}',
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
