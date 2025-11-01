import 'package:flutter/material.dart';

class ErrorFinalWidget {
  static Widget errorWithRetry({
    required BuildContext context,
    required String message,
    String? imageAsset,
    Color? messageTextColor,
    Color? actionTextColor,
    String? actionText,
    Function? action,
  }) =>
      Align(
        alignment: Alignment.center,
        child: SizedBox(
            height: imageAsset != null ? 364 : 260,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (imageAsset != null)
                  Image.asset(
                    imageAsset,
                    height: 96,
                    width: 96,
                  ),
                if (imageAsset != null)
                  const SizedBox(
                    height: 8,
                  ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (action != null && actionText != null)
                  TextButton(
                    onPressed: () => action.call(),
                    child: Text(
                      actionText,
                      style: TextStyle(
                          color: actionTextColor ??
                              Theme.of(context).primaryColor),
                    ),
                  ),
              ],
            )),
      );
}
