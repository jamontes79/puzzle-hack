import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/app/app.dart';
import 'package:puzzle/bootstrap.dart';
import 'package:puzzle/firebase_options.dart';
import 'package:puzzle/injection/injection.dart';

Future<void> main() async {
  configureInjection(Environment.dev);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await bootstrap(() => const App());
}
