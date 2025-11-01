import 'package:flutter/material.dart';

class ConfirmDialog {
  static Future<dynamic> showConfirmation(
          BuildContext context,
          Widget titleWidget,
          Widget contentWidget,
          String? noButtonText,
          String yesButtonText) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          // backgroundColor:
          //     Theme.of(context).dialogBackgroundColor,
          title: titleWidget,
          content: contentWidget,
          actions: <Widget>[
            if (noButtonText != null)
              MaterialButton(
                textColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: Text(noButtonText),
              ),
            MaterialButton(
              textColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(yesButtonText),
            ),
          ],
        ),
      );
}
