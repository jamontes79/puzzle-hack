import 'package:flutter/material.dart';
import 'package:puzzle/authentication/presentation/login_page.dart';
import 'package:puzzle/authentication/presentation/register_page.dart';
import 'package:puzzle/core/presentation/splash_page.dart';
import 'package:puzzle/puzzle/presentation/puzzle_page.dart';

class RouteGenerator {
  static const String splashPage = '/';
  static const String loginPage = '/login';
  static const String registerPage = '/register';
  static const String mainPage = '/main';

  static Route<MaterialPageRoute> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashPage:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(
            key: Key('splash_page'),
          ),
        );
      case loginPage:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(
            key: Key('login_page'),
          ),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(
            key: Key('register_page'),
          ),
        );

      case mainPage:
        return MaterialPageRoute(
          builder: (_) => PuzzlePage(
            key: const Key('puzzle_page'),
          ),
        );
      default:
        throw const FormatException('Route not found');
    }
  }
}
