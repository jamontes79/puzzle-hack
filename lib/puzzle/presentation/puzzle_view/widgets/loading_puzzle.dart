import 'package:flutter/material.dart';
import 'package:puzzle/l10n/l10n.dart';

class LoadingPuzzle extends StatelessWidget {
  const LoadingPuzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Center(
        child: Text(
          l10n.puzzleLoading,
          textAlign: TextAlign.center,
          style: const TextStyle().copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
