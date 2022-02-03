import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/core/domain/failures/failures.dart';
import 'package:puzzle/settings/domain/models/accessibility_settings.dart';
import 'package:puzzle/settings/domain/usecases/i_accessibility.dart';

@LazySingleton(
  as: IAccessibility,
)
class AccessibilityRepository implements IAccessibility {
  AccessibilityRepository(this.getStorage);

  final GetStorage getStorage;

  @override
  Future<Either<Failure, AccessibilitySettings>> get() async {
    final settings = AccessibilitySettings.fromJson(
      getStorage.read<Map<String, dynamic>>('accessibility_settings') ??
          <String, dynamic>{
            'keyboardShortcuts': true,
            'plainText': false,
            'darkMode': false,
            'zoomLevel': 100.0
          },
    );
    return right(settings);
  }

  @override
  Future<Either<Failure, Unit>> save(
    AccessibilitySettings accessibilitySettings,
  ) async {
    await getStorage.write('dark_mode', accessibilitySettings.darkMode);
    await getStorage.write(
      'accessibility_settings',
      accessibilitySettings.toJson(),
    );
    return right(unit);
  }

  @override
  bool isDarkTheme() {
    return getStorage.read<bool>('dark_mode') ?? false;
  }
}
