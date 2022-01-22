import 'package:flutter/material.dart';

class DashLogo extends StatelessWidget {
  const DashLogo({Key? key, this.size = 250}) : super(key: key);
  final double size;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/dash.png',
      width: size,
      height: size,
    );
  }
}
