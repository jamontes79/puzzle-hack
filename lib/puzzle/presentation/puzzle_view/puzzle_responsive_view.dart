import 'package:flutter/material.dart';
import 'package:puzzle/helpers/responsive_helper.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/puzzle_view_mobile_screen.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/puzzle_view_normal_screen.dart';

class PuzzleResponsiveView extends StatelessWidget {
  const PuzzleResponsiveView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device = ResponsiveHelper.getDevice(context);

    if (device == Device.mobile) {
      return const PuzzleViewMobileScreen();
    } else {
      return const PuzzleViewNormalScreen();
    }
  }
}
