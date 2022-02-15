import 'package:flutter/material.dart';

enum Device { mobile, tablet, desktop }

class ResponsiveHelper {
  static Device getDevice(BuildContext context) {
    if (ResponsiveHelper._isMobile(context)) {
      return Device.mobile;
    } else if (ResponsiveHelper._isTablet(context)) {
      return Device.tablet;
    }
    return Device.desktop;
  }

  static bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 700;
  }

  static bool _isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width < 820;
  }

  static bool isHorizontal(BuildContext context) {
    return MediaQuery.of(context).size.width >
        MediaQuery.of(context).size.height;
  }
}
