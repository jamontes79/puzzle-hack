import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/injection/injection.dart';
import 'package:puzzle/l10n/l10n.dart';
import 'package:puzzle/ranking/application/ranking_bloc.dart';

class RankingDialog extends StatelessWidget {
  const RankingDialog({Key? key, required this.level}) : super(key: key);
  final int level;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RankingBloc>()
        ..add(
          RetrieveRanking(level),
        ),
      child: _buildDialog(context),
    );
  }

  AlertDialog _buildDialog(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      shape: _defaultShape(),
      insetPadding: const EdgeInsets.all(8),
      elevation: 10,
      titlePadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 0, 0),
            child: Text(
              l10n.rankingTitle,
              key: const Key('accessibility_dialog_title'),
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
          _getCloseButton(context),
        ],
      ),
      content: BlocBuilder<RankingBloc, RankingState>(
        builder: (context, state) {
          if (state is RankingLoading) {
            return const CircularProgressIndicator();
          } else if (state is RankingLoadSuccessful) {
            final rankings = state.list;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < rankings.length; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rankings[i].username,
                        key: const Key('accessibility_dialog_shortcuts'),
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                      Text(
                        '${rankings[i].numberOfMovements} movs.',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 30,
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  // Returns alert default border style
  ShapeBorder _defaultShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(
        color: Colors.white,
      ),
    );
  }

  Widget _getCloseButton(BuildContext context) {
    return Padding(
      key: const Key('accessibility_dialog_close_button'),
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 30),
      child: GestureDetector(
        child: Container(
          alignment: FractionalOffset.topRight,
          child: InkWell(
            child: Icon(
              Icons.clear,
              key: const Key('accessibility_dialog_close_icon'),
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
