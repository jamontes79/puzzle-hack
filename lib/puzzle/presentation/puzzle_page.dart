import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/authentication/application/auth/auth_bloc.dart';
import 'package:puzzle/helpers/puzzle_size.dart';
import 'package:puzzle/l10n/l10n.dart';
import 'package:puzzle/puzzle/application/bloc/puzzle_bloc.dart';
import 'package:puzzle/puzzle/infrastructure/crop_image.dart';
import 'package:puzzle/puzzle/presentation/puzzle_view/puzzle_responsive_view.dart';
import 'package:puzzle/routes/routes.dart';
import 'package:puzzle/settings/presentation/settings_dialog.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final puzzleSize = PuzzleSizes.getPuzzleSize(context);
    return BlocProvider(
      create: (BuildContext context) => PuzzleBloc(CropImage())
        ..add(
          InitializePuzzle(
            level: 1,
            size: puzzleSize,
          ),
        ),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Puzzle Challenge'),
              actions: [
                InkWell(
                  onTap: () {
                    _showSettingsDialog(context);
                  },
                  child: const Icon(
                    Icons.settings_applications_outlined,
                    key: Key('preferences_icon'),
                    size: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: InkWell(
                    onTap: () {
                      state is Authenticated
                          ? _showLogoutDialog(context)
                          : Navigator.of(context).pushReplacementNamed(
                              RouteGenerator.loginPage,
                            );
                    },
                    child: const Icon(
                      Icons.account_circle_rounded,
                      key: Key('logout_icon'),
                      size: 50,
                    ),
                  ),
                ),
              ],
            ),
            body: const PuzzleView(),
          );
        },
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
    return Scaffold(
      body: BlocListener<PuzzleBloc, PuzzleState>(
        listener: (context, state) {
          if (state.puzzle.getDimension() > 0 && !state.puzzle.isSolvable()) {
            _showNotSolvableDialog(context).then(
              (value) => context.read<PuzzleBloc>().add(
                    const ShufflePuzzle(),
                  ),
            );
          } else if (state.solved) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text:
                  "Level ${state.level} completed! Let's go to the next level!",
              onConfirmBtnTap: () {
                Navigator.of(context, rootNavigator: true).pop();
                context.read<PuzzleBloc>().add(
                      InitializePuzzle(
                        level: state.level + 1,
                        size: PuzzleSizes.getPuzzleSize(context),
                      ),
                    );
              },
            );
          }
        },
        child: const PuzzleResponsiveView(),
      ),
    );
  }

  Future<void> _showNotSolvableDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Puzzle not solvable',
            key: Key('dialog_title'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Current tiles make the resolution impossible.Try it again!',
                  key: Key('dialog_text'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Ok',
                key: Key('dialog_ok_button'),
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
