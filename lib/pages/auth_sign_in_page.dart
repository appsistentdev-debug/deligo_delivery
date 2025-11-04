// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:deligo_delivery/config/page_routes.dart';
import 'package:deligo_delivery/flavors.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deligo_delivery/bloc/app_cubit.dart';
import 'package:deligo_delivery/bloc/auth_cubit.dart';
import 'package:deligo_delivery/config/app_config.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/widgets/confirm_dialog.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';
import 'package:deligo_delivery/widgets/entry_field.dart';
import 'package:deligo_delivery/widgets/loader.dart';
import 'package:deligo_delivery/widgets/toaster.dart';
import 'package:flutter_svg/svg.dart';

import 'auth_sign_up_page.dart';
import 'auth_verification_page.dart';

class AuthSignInPage extends StatelessWidget {
  const AuthSignInPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              Loader.showLoader(context);
            } else {
              Loader.dismissLoader(context);
            }
            if (state is LoginLoaded) {
              gotoHome(context);
            } else if (state is LoginExistsLoaded) {
              if (state.isRegistered) {
                gotoVerification(
                    context, state.phoneNumberData.phoneNumberNormalised!);
              } else {
                gotoRegistration(context,
                    RegisterData(null, null, null, state.phoneNumberData));
              }
            } else if (state is LoginErrorSocial) {
              if (state.loginName != null &&
                  state.loginName!.isNotEmpty &&
                  state.loginEmail != null &&
                  state.loginEmail!.isNotEmpty) {
                Toaster.showToastBottom(AppLocalization.instance
                    .getLocalizationFor(state.messageKey));
                gotoRegistration(
                    context,
                    RegisterData(state.loginName!, state.loginEmail!,
                        state.loginImageUrl, null));
              } else {
                Toaster.showToastBottom(AppLocalization.instance
                    .getLocalizationFor("something_wrong"));
              }
              if (kDebugMode) {
                print("login_error_social: $state");
                print(state);
              }
            } else if (state is LoginError) {
              Toaster.showToastBottom(AppLocalization.instance
                  .getLocalizationFor(state.messageKey));
              if (kDebugMode) {
                print("login_error:$state");
                print(state);
              }
            }
          },
          child: const SignInUi(),
        ),
      );

  void gotoHome(BuildContext context) {
    BlocProvider.of<AppCubit>(context).initAuthenticated();
  }

  void gotoVerification(BuildContext context, String phoneNumber) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AuthVerificationPage(phoneNumber)));
  }

  void gotoRegistration(BuildContext context, RegisterData registerData) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AuthSignUpPage(registerData)));
  }
}

class SignInUi extends StatefulWidget {
  const SignInUi({super.key});

  @override
  SignInUiState createState() => SignInUiState();
}

class SignInUiState extends State<SignInUi> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  String? _dialCode, _isoCode;

  @override
  void initState() {
    super.initState();
    if (AppConfig.isDemoMode) {
      _isoCode = "IN";
      _dialCode = '+91';
      _numberController.text = AppConfig.demoNumber;
      _countryController.text = "India";
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showIntroPage();
    });
  }

  Future<void> _showIntroPage() async {
    final bool isPrompted = await LocalDataLayer().getIsIntroShown();

    if (!isPrompted) {
      if (mounted) {
        await Navigator.pushNamed(context, PageRoutes.onboardingPage);
        await LocalDataLayer().setIsIntroShown();
      }
    }

    if (AppConfig.isDemoMode && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            AppLocalization.instance.getLocalizationFor("demo_login_title"),
          ),
          content: Text(AppLocalization.instance
              .getLocalizationFor("demo_login_message")),
          actions: <Widget>[
            MaterialButton(
              textColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalization.instance.getLocalizationFor("okay")),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return Scaffold(
        body: FadedSlideAnimation(
      beginOffset: const Offset(0, 0.3),
      endOffset: const Offset(0, 0),
      slideDuration: const Duration(milliseconds: 300),
      slideCurve: Curves.linearToEaseOut,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: F.appFlavor == Flavor.delivery
                ? SvgPicture.asset(
                    isDark
                        ? 'assets/flavors/logo/deligo/logo_light.svg'
                        : 'assets/flavors/logo/deligo/logo.svg',
                    height: 150,
                    width: 150,
                  )
                : Image.asset(
                    isDark ? F.logoLight : F.logo,
                    height: 150,
                    width: 150,
                  ),
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16),
            child: Text(
              AppLocalization.instance
                  .getLocalizationFor("continueUsingYourPhoneNumber"),
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Stack(
              children: [
                EntryField(
                  hintText: AppLocalization.instance
                      .getLocalizationFor("selectCountry"),
                  label: AppLocalization.instance
                      .getLocalizationFor("choose_country"),
                  labelHeight: 8,
                  controller: _countryController,
                  suffix: Icon(
                    Icons.arrow_drop_down,
                    color: theme.hintColor,
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: CountryCodePicker(
                    initialSelection: '91',
                    hideMainText: true,
                    dialogBackgroundColor: isDark ? Colors.black : Colors.white,
                    dialogTextStyle: theme.textTheme.bodyMedium
                        ?.copyWith(color: isDark ? Colors.white : Colors.black),
                    textStyle: theme.textTheme.bodyMedium
                        ?.copyWith(color: isDark ? Colors.white : Colors.black),
                    searchStyle: theme.textTheme.bodyMedium
                        ?.copyWith(color: isDark ? Colors.white : Colors.black),
                    searchDecoration: InputDecoration(
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 20,
                      ),
                      fillColor: isDark ? Colors.black12 : Colors.white10,
                      prefixIconColor: isDark ? Colors.black : Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.hintColor.withValues(alpha: 0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.hintColor.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if ((_dialCode == null || value.dialCode != _dialCode) ||
                          (_isoCode == null || value.code != _isoCode)) {
                        _dialCode = value.dialCode;
                        _isoCode = value.code;
                        _countryController.text = value.name ?? "";

                        _numberController.clear();
                        setState(() {});
                      }
                    },
                    dialogSize: Size(MediaQuery.of(context).size.width * 0.8,
                        MediaQuery.of(context).size.height * 0.8),
                    showFlag: false,
                    showFlagDialog: true,
                    favorite: const ['+91', 'US'],
                    showCountryOnly: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: EntryField(
                hintText: (_dialCode != null && _dialCode!.isNotEmpty)
                    ? "${AppLocalization.instance.getLocalizationFor("enter_phone_exluding")} $_dialCode"
                    : AppLocalization.instance
                        .getLocalizationFor("enter_phone_number"),
                label:
                    AppLocalization.instance.getLocalizationFor("enter_phone"),
                labelHeight: 8,
                controller: _numberController,
                keyboardType: TextInputType.phone,
              ),
            ),
          ),
          CustomButton(
            margin: const EdgeInsets.all(22.0),
            onTap: () => _checkAndLogin(),
          ),
        ],
      ),
    ));
  }

  Future<void> _checkAndLogin() async {
    if (_dialCode == null || _dialCode!.isEmpty) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("choose_country"));
      return;
    }
    if (_numberController.text.trim().isEmpty) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("enter_phone"));
      return;
    }
    ConfirmDialog.showConfirmation(
            context,
            Text("$_dialCode${_numberController.text.trim()}"),
            Text(AppLocalization.instance.getLocalizationFor("alert_phone")),
            AppLocalization.instance.getLocalizationFor("no"),
            AppLocalization.instance.getLocalizationFor("yes"))
        .then((value) {
      if (value != null && value == true) {
        BlocProvider.of<AuthCubit>(context).initLoginPhone(PhoneNumberData(
            _countryController.text,
            _isoCode,
            _dialCode,
            _numberController.text,
            null));
      }
    });
  }
}
