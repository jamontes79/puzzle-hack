import 'package:flutter/cupertino.dart';
import 'package:puzzle/helpers/responsive_helper.dart';

class PuzzleSizes {
  static double getPuzzleSize(BuildContext context) {
    final device = ResponsiveHelper.getDevice(context);
    late double puzzleSize;
    switch (device) {
      case Device.mobile:
        puzzleSize = 300;
        break;
      case Device.tablet:
        puzzleSize = 400;
        break;
      case Device.desktop:
        puzzleSize = 500;
        break;
    }

    return puzzleSize;
  }

  static double getBoardSize(BuildContext context) {
    final device = ResponsiveHelper.getDevice(context);
    late double boardSize;
    switch (device) {
      case Device.mobile:
        boardSize = 320;
        break;
      case Device.tablet:
        boardSize = 420;
        break;
      case Device.desktop:
        boardSize = 520;
        break;
    }
    return boardSize;
  }

  static double getTileSize(
    BuildContext context,
    int puzzleDimension,
  ) {
    return getPuzzleSize(context) / puzzleDimension;
  }
}
