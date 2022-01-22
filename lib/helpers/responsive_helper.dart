import 'package:flutter/material.dart';

enum Device { mobile, tablet, desktop }

class ResponsiveHelper {
  static Device getDevice(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return Device.mobile;
    } else if (ResponsiveHelper.isTablet(context)) {
      return Device.tablet;
    }
    return Device.desktop;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 540;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width < 700;
  }
}
