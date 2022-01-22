import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/puzzle/application/bloc/puzzle_bloc.dart';
import 'package:puzzle/puzzle/infrastructure/crop_image.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/puzzle_responsive_view.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const image = 'caleta.png';
    final width = MediaQuery.of(context).size.width;
    late double puzzleSize;
    if (width < 768) {
      puzzleSize = 300;
    } else {
      puzzleSize = 600;
    }
    return BlocProvider(
      create: (BuildContext context) => PuzzleBloc(CropImage())
        ..add(
          InitializePuzzle(image: image, dimension: 3, size: puzzleSize),
        ),
      child: Scaffold(
        appBar: AppBar(),
        body: const PuzzleView(
          image: image,
        ),
      ),
    );
  }
}

class PuzzleView extends StatelessWidget {
  const PuzzleView({Key? key, required this.image}) : super(key: key);
  final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PuzzleBloc, PuzzleState>(
        listener: (context, state) {
          if (state.puzzle.getDimension() > 0 && !state.puzzle.isSolvable()) {
            _showNotSolvableDialog(context).then(
              (value) => context.read<PuzzleBloc>().add(
                    const ShufflePuzzle(),
                  ),
            );
          }
        },
        child: PuzzleResponsiveView(image: image),
      ),
    );
  }

  Future<void> _showNotSolvableDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Puzzle not solvable',
            key: Key('dialog_title'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Current tiles make the resolution impossible.Try it again!',
                  key: Key('dialog_text'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Ok',
                key: Key('dialog_ok_button'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
