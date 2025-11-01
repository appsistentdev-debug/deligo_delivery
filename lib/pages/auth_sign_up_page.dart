// ignore_for_file: deprecated_member_use

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:deligo_delivery/bloc/auth_cubit.dart';
import 'package:deligo_delivery/config/app_config.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/widgets/confirm_dialog.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';
import 'package:deligo_delivery/widgets/entry_field.dart';
import 'package:deligo_delivery/widgets/loader.dart';
import 'package:deligo_delivery/widgets/regular_app_bar.dart';
import 'package:deligo_delivery/widgets/toaster.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_verification_page.dart';

class AuthSignUpPage extends StatelessWidget {
  final RegisterData registerRequest;

  const AuthSignUpPage(this.registerRequest, {super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is RegisterLoading) {
              Loader.showLoader(context);
            } else {
              Loader.dismissLoader(context);
            }
            if (state is RegisterLoaded) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthVerificationPage(
                          state.authResponse.user.mobile_number)));
            } else if (state is RegisterError) {
              Toaster.showToastBottom(AppLocalization.instance
                  .getLocalizationFor(state.messageKey));
              if (kDebugMode) {
                print("register_error: ${state.messageKey}");
              }
            }
          },
          child: SignUpUI(registerRequest),
        ),
      );
}

class SignUpUI extends StatefulWidget {
  final RegisterData registerData;

  const SignUpUI(this.registerData, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<SignUpUI> createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {
  RegisterData get registerData => widget.registerData;
  late TextEditingController _nameController,
      _emailController,
      _phoneController,
      // ignore: unused_field
      _countryController;
  String? _isoCode, _dialCode;

  void _init() {
    _nameController = TextEditingController(text: registerData.name);
    _emailController = TextEditingController(text: registerData.email);
    if (registerData.phoneNumberData != null) {
      _phoneController = TextEditingController(
          text: registerData.phoneNumberData!.phoneNumber);
      _countryController = TextEditingController(
          text: registerData.phoneNumberData!.countryText);
      _isoCode = registerData.phoneNumberData!.isoCode;
      _dialCode = registerData.phoneNumberData!.dialCode;
    } else {
      _phoneController = TextEditingController();
      _countryController = TextEditingController();
    }
  }

  @override
  void initState() {
    _init();
    if (AppConfig.isDemoMode && registerData.phoneNumberData == null) {
      _isoCode = "IN";
      _dialCode = '+91';
      _phoneController.text = AppConfig.demoNumber;
      _countryController.text = "India";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegularAppBar(
        title: AppLocalization.instance.getLocalizationFor("registerNow"),
      ),
      body: FadedSlideAnimation(
        beginOffset: const Offset(0, 0.3),
        endOffset: const Offset(0, 0),
        slideDuration: const Duration(milliseconds: 300),
        slideCurve: Curves.linearToEaseOut,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          AppLocalization.instance.getLocalizationFor(
                              "looksLikeYourPhoneNumberNot"),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 30),
                        EntryField(
                          label: AppLocalization.instance
                              .getLocalizationFor("fullName"),
                          controller: _nameController,
                        ),
                        const SizedBox(height: 24),
                        EntryField(
                          label: AppLocalization.instance
                              .getLocalizationFor("phoneNumber"),
                          initialValue: registerData
                              .phoneNumberData!.phoneNumberNormalised,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                        ),
                        const SizedBox(height: 24),

                        EntryField(
                          label: AppLocalization.instance
                              .getLocalizationFor("emailAddress"),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        // const SizedBox(height: 30),
                        // EntryField(
                        //   label: AppLocalization.instance
                        //       .getLocalizationFor("doYouHaveReferral"),
                        //   hintText: AppLocalization.instance
                        //       .getLocalizationFor("enterReferralCode"),
                        //   keyboardType: TextInputType.emailAddress,
                        // ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomButton(
              onTap: () => _checkAndRegister(),
              margin: const EdgeInsets.all(20),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkAndRegister() async {
    if (_nameController.text.trim().length < 3) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("enter_name"));
      return;
    }
    if (_emailController.text.trim().isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_emailController.text.trim())) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("enter_email"));
      return;
    }
    if (_isoCode == null || _isoCode!.isEmpty) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("choose_country"));
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("enter_phone"));
      return;
    }
    ConfirmDialog.showConfirmation(
            context,
            Text("$_dialCode${_phoneController.text.trim()}"),
            Text(AppLocalization.instance.getLocalizationFor("alert_phone")),
            AppLocalization.instance.getLocalizationFor("no"),
            AppLocalization.instance.getLocalizationFor("yes"))
        .then((value) {
      if (value != null && value == true && mounted) {
        BlocProvider.of<AuthCubit>(context).initRegistration(
            _dialCode!,
            _phoneController.text.trim(),
            _nameController.text.trim(),
            _emailController.text.trim(),
            null,
            registerData.imageUrl);
      }
    });
  }
}
