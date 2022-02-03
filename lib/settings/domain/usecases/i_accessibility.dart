import 'package:dartz/dartz.dart';
import 'package:puzzle/core/domain/failures/failures.dart';
import 'package:puzzle/settings/domain/models/accessibility_settings.dart';

abstract class IAccessibility {
  bool isDarkTheme();
  Future<Either<Failure, AccessibilitySettings>> get();
  Future<Either<Failure, Unit>> save(
    AccessibilitySettings accessibilitySettings,
  );
}
