// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:puzzle/authentication/application/auth/auth_bloc.dart';
import 'package:puzzle/injection/injection.dart';
import 'package:puzzle/l10n/l10n.dart';
import 'package:puzzle/routes/routes.dart';
import 'package:puzzle/settings/application/settings_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<SettingsBloc>()
            ..add(
              const RequestAccessibilitySettings(),
            ),
        ),
        BlocProvider(
          create: (_) => getIt<AuthBloc>()
            ..add(
              const CheckStatus(),
            ),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: Colors.blueAccent,
              appBarTheme: const AppBarTheme(
                color: Color.fromARGB(255, 19, 74, 159),
              ),
              colorScheme: ColorScheme.fromSwatch(
                accentColor: const Color(0xFF13B9FF),
              ),
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            debugShowCheckedModeBanner: false,
            initialRoute: RouteGenerator.splashPage,
            onGenerateRoute: RouteGenerator.generateRoute,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
