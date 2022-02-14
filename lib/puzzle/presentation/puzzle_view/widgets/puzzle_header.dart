import 'package:flutter/material.dart';
import 'package:puzzle/l10n/l10n.dart';

class PuzzleHeader extends StatelessWidget {
  const PuzzleHeader({Key? key, required this.level}) : super(key: key);
  final int level;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Text(
      '${l10n.puzzleHeader} $level',
      style: Theme.of(context).textTheme.headline4?.copyWith(
            color: Colors.white,
          ),
    );
  }
}
