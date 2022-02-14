import 'package:flutter/material.dart';

class LoadingPuzzle extends StatelessWidget {
  const LoadingPuzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Center(
        child: Text(
          'Loading puzzle...\nWait a second, please',
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
