import 'package:confetti/confetti.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/authentication/application/auth/auth_bloc.dart';
import 'package:puzzle/helpers/puzzle_size.dart';
import 'package:puzzle/injection/injection.dart';
import 'package:puzzle/l10n/l10n.dart';
import 'package:puzzle/puzzle/application/bloc/puzzle_bloc.dart';
import 'package:puzzle/puzzle/infrastructure/crop_image.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/puzzle_responsive_view.dart';
import 'package:puzzle/ranking/application/ranking_bloc.dart';
import 'package:puzzle/ranking/presentation/ranking_dialog.dart';
import 'package:puzzle/routes/routes.dart';
import 'package:puzzle/settings/presentation/settings_dialog.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final puzzleSize = PuzzleSizes.getPuzzleSize(context);
    var currentLevel = 1;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => PuzzleBloc(CropImage())
            ..add(
              InitializePuzzle(
                level: 1,
                size: puzzleSize,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => getIt<RankingBloc>(),
        ),
      ],
      child: BlocListener<PuzzleBloc, PuzzleState>(
        listenWhen: (oldState, newState) {
          return oldState.level != newState.level;
        },
        listener: (context, state) {
          Navigator.of(context, rootNavigator: true).pop();
          currentLevel = state.level;
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return ScaffoldGradientBackground(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.tertiary
                ],
              ),
              appBar: AppBar(
                title: Text(l10n.appBarTitle),
                actions: [
                  PopupMenuButton(
                    color: Theme.of(context).colorScheme.background,
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'Settings') {
                        _showSettingsDialog(context);
                      } else if (value == 'Login') {
                        Navigator.of(context).pushReplacementNamed(
                          RouteGenerator.loginPage,
                        );
                      } else if (value == 'Logout') {
                        _showLogoutDialog(context);
                      } else if (value == 'Ranking') {
                        _showRankingDialog(context, currentLevel);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'Settings',
                        child: Text(l10n.menuSettings),
                      ),
                      PopupMenuItem(
                        value: 'Ranking',
                        // enabled: state is Authenticated,
                        child: Text(l10n.menuRanking),
                      ),
                      PopupMenuItem(
                        value: state is Authenticated ? 'Logout' : 'Login',
                        child: Text(
                          state is Authenticated
                              ? l10n.menuLogout
                              : l10n.menuLogin,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              body: const SingleChildScrollView(
                child: PuzzleView(),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showSettingsDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext buildContext,
        Animation animation,
        Animation secondaryAnimation,
      ) {
        return const SettingsDialog(
          key: Key('accessibility_dialog'),
        );
      },
    );
  }

  Future<void> _showRankingDialog(BuildContext context, int level) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext buildContext,
        Animation animation,
        Animation secondaryAnimation,
      ) {
        return RankingDialog(
          key: const Key('ranking_dialog'),
          level: level,
        );
      },
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(
            l10n.logoutQuestionTitle,
            key: const Key('logout_title'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  l10n.logoutQuestionText,
                  key: const Key('logout_text'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                l10n.logoutOkButton,
                key: const Key('logout_ok_button'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(const Logout());
              },
            ),
            TextButton(
              child: Text(
                l10n.logoutCancelButton,
                key: const Key('logout_cancel_button'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class PuzzleView extends StatelessWidget {
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final _controller =
        ConfettiController(duration: const Duration(seconds: 10));
    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (context, state) {
        if (state.solved) {
          context.read<RankingBloc>().add(
                SaveRanking(
                  numberOfMovements: state.currentMoves,
                  level: state.level,
                ),
              );

          _controller.play();
          if (state.level == 3) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              backgroundColor: Theme.of(context).primaryColor,
              text: l10n.gameFinished,
              onConfirmBtnTap: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            );
          } else {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              backgroundColor: Theme.of(context).primaryColor,
              text: l10n.levelCompleted.replaceFirst(
                '#level#',
                state.level.toString(),
              ),
              onConfirmBtnTap: () {
                _controller.stop();

                context.read<PuzzleBloc>().add(
                      InitializePuzzle(
                        level: state.level + 1,
                        size: PuzzleSizes.getPuzzleSize(context),
                      ),
                    );
              },
            );
          }
        }
      },
      child: Stack(
        children: [
          const PuzzleResponsiveView(),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  true, // start again as soon as the animation is finished
              // define a custom shape/path.
            ),
          ),
        ],
      ),
    );
  }
}
