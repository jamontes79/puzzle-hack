import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/puzzle/application/bloc/puzzle_bloc.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      child: OutlinedButton(
        onPressed: () {
          context.read<PuzzleBloc>().add(
                const ShufflePuzzle(),
              );
        },
        child: Row(
          children: const [
            Icon(
              Icons.refresh,
              key: Key('accessibility_button_icon'),
            ),
            SizedBox(
              width: 10,
            ),
            Text('Shuffle'),
          ],
        ),
      ),
    );
  }
}
