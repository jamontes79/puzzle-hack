import 'package:flutter/material.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/puzzle_view_mobile_screen.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/puzzle_view_normal_screen.dart';

class PuzzleResponsiveView extends StatelessWidget {
  const PuzzleResponsiveView({Key? key, required this.image}) : super(key: key);
  final String image;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 768) {
      return PuzzleViewMobileScreen(
        image: image,
      );
    } else {
      return PuzzleViewNormalScreen(
        image: image,
      );
    }
  }
}
