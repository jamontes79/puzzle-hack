import 'package:flutter/material.dart';
import 'package:puzzle/l10n/l10n.dart';

class RankingDialog extends StatelessWidget {
  const RankingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildDialog(context);
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < 5; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User $i',
                  key: const Key('accessibility_dialog_shortcuts'),
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.black,
                      ),
                ),
                Text(
                  '10 movs.',
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
