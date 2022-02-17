fvm flutter format --set-exit-if-changed lib test
fvm flutter analyze lib test
fvm flutter test --coverage --test-randomize-ordering-seed random
fvm flutter pub run remove_from_coverage -f coverage/lcov.info -r '.freezed.dart$|.config.dart$|firebase_injectable_module.dart$|.g.dart$|routes.dart$'
genhtml coverage/lcov.info -o coverage/