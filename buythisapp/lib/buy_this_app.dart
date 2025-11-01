// ignore_for_file: constant_identifier_names

//library buy_this_app;

import 'package:buy_this_app/SubscribeBloc/subscribe_cubit.dart';
import 'package:buy_this_app/UI/buy_this_app_button.dart';
import 'package:buy_this_app/UI/developer_row.dart';
import 'package:buy_this_app/UI/subscribe_dialog.dart';
import 'package:buy_this_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///the main class of buy this app package
class BuyThisApp {
  ///opens subscribe dialog for the user to subscribe to us
  ///SubscribeDialog is the Dialog widget
  ///BuildContext is necessary
  static Future showSubscribeDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => BlocProvider<SubscribeCubit>(
          create: (context) => SubscribeCubit(),
          child: SubscribeDialog(),
        ),
      );

  ///buyThisAppButton will create the button on the screen which will be of fixed size
  ///color parameter can be passed to give the color to the button
  ///default value of color is Colors.red
  ///appName is the name of the current app
  ///app name is also necessary
  ///target is used for redirection
  ///default value of target is Target.Both
  ///ButThisAppButton is the button widget
  static Widget button(
    String appName,
    String codeCanyonUrl, {
    Color? color,
    Target target = Target.Both,
    double height = 48,
    String source = 'template_flutter',
  }) =>
      BuyThisAppButton(appName, codeCanyonUrl, color, target, height, source);

  static Widget buttonCustom(
    BuildContext context,
    Widget widget,
    String appName,
    String codeCanyonUrl, {
    Target target = Target.Both,
    String source = 'template_flutter',
  }) =>
      BuyThisAppCustomButton(widget, appName, codeCanyonUrl, target, source);

  static Widget developerRow(Color backgroundColor, Color textColor) =>
      BuyThisApp.developerRowOpus(backgroundColor, textColor);

  static Widget developerRowOpus(Color backgroundColor, Color textColor) =>
      DeveloperRow.opus(backgroundColor, textColor);

  static Widget developerRowVerbose(Color backgroundColor, Color textColor) =>
      DeveloperRow.verbose(backgroundColor, textColor);

  static Widget developerRowOpusDark(Color backgroundColor, Color textColor) =>
      DeveloperRow.opusDark(backgroundColor, textColor);

  static Widget developerRowVerboseDark(
          Color backgroundColor, Color textColor) =>
      DeveloperRow.verboseDark(backgroundColor, textColor);

  static const AppLocalizationDelegate delegate = S.delegate;
}

enum Target {
  CodeCanyon,
  Both,
  WhatsApp,
}
