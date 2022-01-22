import 'package:flutter/material.dart';

class PuzzleHeader extends StatelessWidget {
  const PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Puzzle Challenge',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
