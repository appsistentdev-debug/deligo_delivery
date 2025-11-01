// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deligo_delivery/bloc/theme_cubit.dart';
import 'package:deligo_delivery/config/colors.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shimmer/shimmer.dart';

class Loader {
  static bool _isLoaderShowing = false;
  static ProgressDialog? _progressDialog;

  static Widget loadingShimmerAppointment(BuildContext context) => Stack(
        children: [
          Shimmer.fromColors(
            baseColor: BlocProvider.of<ThemeCubit>(context).isDark
                ? gradientColor2
                : gradientColor2Light,
            highlightColor: BlocProvider.of<ThemeCubit>(context).isDark
                ? gradientColor1
                : gradientColor1Light,
            child: Container(
              margin: const EdgeInsetsDirectional.only(
                  start: 60, end: 16, bottom: 8),
              padding: const EdgeInsetsDirectional.only(
                  start: 20, end: 20, bottom: 12, top: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              height: 84,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          PositionedDirectional(
            start: 12,
            top: 12,
            child: Shimmer.fromColors(
              baseColor: BlocProvider.of<ThemeCubit>(context).isDark
                  ? gradientColor2
                  : gradientColor2Light,
              highlightColor: BlocProvider.of<ThemeCubit>(context).isDark
                  ? gradientColor1
                  : gradientColor1Light,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  color: Colors.black,
                  height: 60,
                  width: 60,
                ),
              ),
            ),
          )
        ],
      );

  static Widget loadingWidget(
          {required BuildContext context, String? message}) =>
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
              ),
              Text(
                message != null && message.isNotEmpty
                    ? message
                    : AppLocalization.instance.getLocalizationFor("loading"),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 17),
              ),
            ],
          ),
        ),
      );

  static void showLoader(BuildContext context) {
    if (!_isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) =>
            Center(child: Loader.circularProgressIndicatorPrimary(context)),
      );
      _isLoaderShowing = true;
    }
  }

  static void dismissLoader(BuildContext context) {
    if (_isLoaderShowing) {
      Navigator.of(context).pop();
      _isLoaderShowing = false;
    }
  }

  static void showProgress(
      BuildContext context, String progressTitleText, String progressBodyText) {
    if (_progressDialog == null) {
      _progressDialog = ProgressDialog(context,
          dismissable: false,
          defaultLoadingWidget:
              Loader.circularProgressIndicatorPrimary(context),
          title: Text(
            progressTitleText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 17,
                  //color: Colors.black,
                ),
          ),
          message: Text(
            progressBodyText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 14,
                  //color: Colors.grey,
                ),
          ));
    } else {
      _progressDialog!.setTitle(Text(
        progressTitleText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 17,
              //color: Colors.black,
            ),
      ));
      _progressDialog!.setMessage(Text(
        progressBodyText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 14,
              //color: Colors.grey,
            ),
      ));
    }
    _progressDialog!.show();
  }

  static void dismissProgress() {
    if (_progressDialog != null) {
      _progressDialog!.dismiss();
      _progressDialog = null;
    }
  }

  static Center circularProgressIndicatorPrimary(BuildContext context) =>
      Center(
          child: CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ));

  static Center circularProgressIndicatorWhite() => const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ));

  static Center circularProgressIndicatorDefault() =>
      const Center(child: CircularProgressIndicator());
}
