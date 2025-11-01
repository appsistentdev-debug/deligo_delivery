// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:deligo_delivery/widgets/regular_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deligo_delivery/bloc/app_cubit.dart';
import 'package:deligo_delivery/bloc/auth_cubit.dart';
import 'package:deligo_delivery/config/app_config.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';
import 'package:deligo_delivery/widgets/entry_field.dart';
import 'package:deligo_delivery/widgets/loader.dart';
import 'package:deligo_delivery/widgets/toaster.dart';

class AuthVerificationPage extends StatelessWidget {
  final String phoneNumber;

  const AuthVerificationPage(this.phoneNumber, {super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => AuthCubit(),
        child: VerificationUI(phoneNumber),
      );
}

class VerificationUI extends StatefulWidget {
  final String phoneNumber;
  const VerificationUI(this.phoneNumber, {super.key});

  @override
  State<VerificationUI> createState() => _VerificationUIState();
}

class _VerificationUIState extends State<VerificationUI> {
  Timer? _timer;
  int _timeLeft = 60;

  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context).initAuthentication(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is VerificationLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is VerificationSentLoaded) {
          _initTimer();
          Toaster.showToastBottom(
              AppLocalization.instance.getLocalizationFor("code_sent"));
          if (AppConfig.isDemoMode &&
              widget.phoneNumber.contains(AppConfig.demoNumber)) {
            BlocProvider.of<AuthCubit>(context).verifyOtp("123456");
          }
        } else if (state is VerificationVerifyingLoaded) {
          Navigator.pop(context);
          BlocProvider.of<AppCubit>(context).initAuthenticated();
        } else if (state is VerificationError) {
          Toaster.showToastBottom(
              AppLocalization.instance.getLocalizationFor(state.messageKey));
          // if (state.messageKey == "something_wrong" ||
          //     state.messageKey == "role_exists") {
          //   Navigator.of(context).pop();
          // }
        }
      },
      child: Scaffold(
        appBar: RegularAppBar(
            title: AppLocalization.instance.getLocalizationFor("verification")),
        // appBar: AppBar(
        //   title: Text(
        //     AppLocalization.instance.getLocalizationFor("verification"),
        //     style:
        //         Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
        //   ),
        // ),
        body: FadedSlideAnimation(
          beginOffset: const Offset(0, 0.3),
          endOffset: const Offset(0, 0),
          slideDuration: const Duration(milliseconds: 300),
          slideCurve: Curves.linearToEaseOut,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            children: [
              const SizedBox(height: 20),
              Text(
                '${AppLocalization.instance.getLocalizationFor("enterVerificationCodeSentOn")}\n${AppLocalization.instance.getLocalizationFor("givenNumber")}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 22),
              EntryField(
                label: AppLocalization.instance
                    .getLocalizationFor("verificationCode"),
                hintText: AppLocalization.instance
                    .getLocalizationFor("enterInformation"),
                controller: _otpController,
                keyboardType: TextInputType.number,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '0:${_timeLeft.toString().padLeft(2, '0')} ${AppLocalization.instance.getLocalizationFor("secLeft")}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    AppLocalization.instance.getLocalizationFor("resend"),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              CustomButton(
                label: AppLocalization.instance.getLocalizationFor("submit"),
                onTap: () {
                  if (_otpController.text.trim().isEmpty) {
                    Toaster.showToastCenter(AppLocalization.instance
                        .getLocalizationFor("otp_invalid"));
                    return;
                  }
                  BlocProvider.of<AuthCubit>(context)
                      .verifyOtp(_otpController.text.trim());
                },
              ),
            ],
          ),
        ),
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(left: 32, bottom: 16),
        //   child:
        // ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_timeLeft == 0) {
          setState(() => timer.cancel());
        } else {
          setState(() => _timeLeft--);
        }
      },
    );
  }
}
