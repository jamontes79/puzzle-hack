import 'package:flutter/material.dart';

class LoadingPuzzle extends StatelessWidget {
  const LoadingPuzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Loading puzzle...\nWait a second, please',
        textAlign: TextAlign.center,
        style: const TextStyle().copyWith(
          fontSize: 24,
          color: Colors.blue,
        ),
      ),
    );
  }
}
