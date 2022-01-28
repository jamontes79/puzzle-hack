import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/puzzle/application/bloc/puzzle_bloc.dart';
import 'package:puzzle/puzzle/presentation/puzzle_board/puzzle_board.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/dash_logo.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/loading_puzzle.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/puzzle_header.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/suffle_button.dart';

class PuzzleViewMobileScreen extends StatelessWidget {
  const PuzzleViewMobileScreen({Key? key}) : super(key: key);

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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PuzzleBoard(
                    puzzle: state.puzzle,
                  ),
                  const DashLogo(size: 130),
                ],
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Number of movements: ${state.currentMoves}\n'
                            'Tiles Correct: ${state.tilesCorrect}\n',
                            style: const TextStyle().copyWith(
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ),
                          Image.asset(
                            'assets/puzzles/${state.puzzle.image}',
                            width: 100,
                            height: 100,
                          ),
                        ],
                      ),
                      const ShuffleButton(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
