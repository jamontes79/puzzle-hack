import 'package:flutter/material.dart';
import 'package:puzzle/helpers/responsive_helper.dart';

class DashLogo extends StatelessWidget {
  const DashLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device = ResponsiveHelper.getDevice(context);
    late double size;
    if (device == Device.desktop) {
      size = 250;
    } else if (device == Device.tablet) {
      size = 150;
    } else {
      size = 70;
    }
    return Image.asset(
      'assets/images/dash.png',
      width: size,
      height: size,
    );
  }
}
