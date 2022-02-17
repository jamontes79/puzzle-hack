import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:puzzle/authentication/application/auth/auth_bloc.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';
import 'package:puzzle/authentication/domain/models/puzzle_user.dart';
import 'package:puzzle/authentication/domain/usecases/i_auth.dart';
import 'package:puzzle/core/presentation/splash_page.dart';
import 'package:puzzle/injection/injection.dart';
import 'package:puzzle/l10n/l10n.dart';
import 'package:puzzle/routes/routes.dart';

import '../../helpers/firebase_mock.dart';
import '../../helpers/helpers.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockAuth extends Mock implements IAuth {}

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    configureInjection(Environment.test);
    WidgetController.hitTestWarningShouldBeFatal = true;
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  group('SplashPage', () {
    late AuthBloc authBloc;

    setUp(() {
      authBloc = MockAuthBloc();

      when(() => authBloc.state).thenReturn(
        const Unauthenticated(),
      );
    });
    testWidgets('renders SplashPage', (tester) async {
      when(() => authBloc.state).thenReturn(
        const Unauthenticated(),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: authBloc,
          child: const SplashPage(
            key: Key('splash_page'),
          ),
        ),
      );
      expect(find.byType(SplashView), findsOneWidget);
    });
  });
  group('SplashView', () {
    testWidgets('check appears circular indicator', (tester) async {
      await tester.pumpApp(
        const SplashView(
          key: Key('splash_view'),
        ),
      );
      expect(
        find.byKey(const Key('splashpage_circular_indicator')),
        findsOneWidget,
      );
    });
  });
  group('Navigation from Splash', () {
    late MockNavigator navigator;
    late MockAuth mockAuth;
    setUp(() {
      mockAuth = MockAuth();
      navigator = MockNavigator();
    });

    testWidgets('SplashPage navigates to login when non auth', (tester) async {
      when(() => navigator.pushReplacementNamed(RouteGenerator.loginPage))
          .thenAnswer(
        (_) async => Future.value(),
      );
      when(() => mockAuth.getSignedUser()).thenAnswer(
        (_) async => left(
          const NotLoggedUserFailure(),
        ),
      );
      await tester.pumpApp(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          home: MockNavigatorProvider(
            navigator: navigator,
            child: BlocProvider(
              create: (_) => AuthBloc(mockAuth)
                ..add(
                  const CheckStatus(),
                ),
              child: const SplashPage(
                key: Key('splash_page'),
              ),
            ),
          ),
        ),
      );
      verify(
        () => navigator.pushReplacementNamed(RouteGenerator.loginPage),
      ).called(1);
    });
    testWidgets('SplashPage navigates to main when is auth', (tester) async {
      const user = PuzzleUser(id: 'id', username: 'username');
      when(() => navigator.pushReplacementNamed(RouteGenerator.mainPage))
          .thenAnswer(
        (_) async => Future.value(),
      );
      when(() => mockAuth.getSignedUser()).thenAnswer(
        (_) async => right(
          user,
        ),
      );
      await tester.pumpApp(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          home: MockNavigatorProvider(
            navigator: navigator,
            child: BlocProvider(
              create: (_) => AuthBloc(mockAuth)
                ..add(
                  const CheckStatus(),
                ),
              child: const SplashPage(
                key: Key('splash_page'),
              ),
            ),
          ),
        ),
      );
      verify(
        () => navigator.pushReplacementNamed(RouteGenerator.mainPage),
      ).called(1);
    });
  });
}
