import 'package:flutter/material.dart';

class PuzzleHeader extends StatelessWidget {
  const PuzzleHeader({Key? key, required this.level}) : super(key: key);
  final int level;
  @override
  Widget build(BuildContext context) {
    return Text(
      'Level $level',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
