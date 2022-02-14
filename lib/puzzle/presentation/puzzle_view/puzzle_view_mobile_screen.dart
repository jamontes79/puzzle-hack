import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/l10n/l10n.dart';
import 'package:puzzle/puzzle/application/bloc/puzzle_bloc.dart';
import 'package:puzzle/puzzle/presentation/puzzle_board/puzzle_board.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/dash_logo.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/loading_puzzle.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/puzzle_header.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/widgets/suffle_button.dart';
import 'package:puzzle/speech/infrastructure/speech_recognition.dart';

class PuzzleViewMobileScreen extends StatelessWidget {
  const PuzzleViewMobileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<PuzzleBloc, PuzzleState>(
      listenWhen: (oldState, newState) {
        return newState.voiceCommands;
      },
      listener: (context, state) {
        if (state.voiceCommands &&
            state.errorVoiceCommand &&
            state.lastVoiceCommand.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${l10n.puzzleVoiceCommandNotRecognized} '
                '(${state.lastVoiceCommand})',
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.loading || state.puzzle.image.isEmpty) {
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
                    speechRecognition: SpeechRecognition(),
                  ),
                  const DashLogo(size: 70),
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
                            '${l10n.puzzleNumberOfMovements}: '
                            '${state.currentMoves}\n'
                            '${l10n.puzzleTilesCorrect}: '
                            '${state.tilesCorrect}',
                            style: const TextStyle().copyWith(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Visibility(
                            visible: state.voiceCommands,
                            child: Text(
                              '${l10n.puzzleLastVoiceCommand}: '
                              '${state.lastVoiceCommand}',
                              style: const TextStyle().copyWith(
                                fontSize: 18,
                                color: Colors.white,
                              ),
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
