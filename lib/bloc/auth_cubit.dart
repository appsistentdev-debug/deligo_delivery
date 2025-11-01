// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deligo_delivery/models/auth_request_register.dart';
import 'package:deligo_delivery/models/auth_response.dart';
import 'package:deligo_delivery/network/remote_repository.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> implements VerificationCallbacks {
  final RemoteRepository _repository = RemoteRepository();

  AuthCubit() : super(const AuthInitial());

  /// SIGNIN BELOW

  void initLoginPhone(PhoneNumberData phoneNumberData) async {
    emit(const LoginLoading());
    if (phoneNumberData.isoCode != null &&
        phoneNumberData.isoCode!.isNotEmpty &&
        phoneNumberData.phoneNumber != null &&
        phoneNumberData.phoneNumber!.isNotEmpty) {
      // bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
      //         phoneNumber: phoneNumberData.phoneNumber!,
      //         isoCode: phoneNumberData.isoCode!) ??
      //     false;
      // if (isValid) {
      try {
        // String? normalizedNumber = await PhoneNumberUtil.normalizePhoneNumber(
        //     phoneNumber: phoneNumberData.phoneNumber!,
        //     isoCode: phoneNumberData.isoCode!);
        //if (normalizedNumber != null) {
        String normalizedNumber =
            "${phoneNumberData.dialCode}${phoneNumberData.phoneNumber}";
        bool isRegistered = await _repository.isRegistered(normalizedNumber);
        emit(LoginExistsLoaded(
            isRegistered,
            PhoneNumberData(
                phoneNumberData.countryText,
                phoneNumberData.isoCode,
                phoneNumberData.dialCode,
                phoneNumberData.phoneNumber,
                normalizedNumber)));
        // } else {
        //   emit(const LoginError("Something went wrong", "something_wrong"));
        // }
      } catch (e) {
        emit(const LoginError("Something went wrong", "something_wrong"));
      }
      // } else {
      //   emit(const LoginError("Invalid phone number", "invalid_phone"));
      // }
    } else {
      emit(const LoginError("Invalid phone number", "invalid_phone"));
    }
  }

  // void initLoginGoogle() async {
  //   emit(const LoginLoading());
  //   try {
  //     final AuthResponseSocial loggedInResponseSocial =
  //         await _repository.signInWithGoogle();
  //     if (loggedInResponseSocial.authResponse != null) {
  //       await LocalDataLayer()
  //           .saveAuthResponse(loggedInResponseSocial.authResponse!);
  //       emit(LoginLoaded(loggedInResponseSocial.authResponse!));
  //     } else if (loggedInResponseSocial.userEmail != null) {
  //       emit(LoginErrorSocial(
  //           loggedInResponseSocial.userName ??
  //               loggedInResponseSocial.userEmail!.split("@")[0],
  //           loggedInResponseSocial.userEmail,
  //           loggedInResponseSocial.userImageUrl,
  //           "User doesn't exist",
  //           "social_user_na"));
  //     } else {
  //       emit(const LoginError("Something went wrong", "something_wrong"));
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     emit(const LoginError("Something went wrong", "something_wrong"));
  //   }
  // }

  // void initLoginFacebook() async {
  //   emit(const LoginLoading());
  //   try {
  //     final AuthResponseSocial loggedInResponseSocial =
  //         await _repository.signInWithFacebook();
  //     if (loggedInResponseSocial.authResponse != null) {
  //       await LocalDataLayer()
  //           .saveAuthResponse(loggedInResponseSocial.authResponse!);
  //       emit(LoginLoaded(loggedInResponseSocial.authResponse!));
  //     } else if (loggedInResponseSocial.userEmail != null) {
  //       emit(LoginErrorSocial(
  //           loggedInResponseSocial.userName ??
  //               loggedInResponseSocial.userEmail!.split("@")[0],
  //           loggedInResponseSocial.userEmail,
  //           loggedInResponseSocial.userImageUrl,
  //           "User doesn't exist",
  //           "social_user_na"));
  //     } else {
  //       emit(const LoginError("Something went wrong", "something_wrong"));
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     emit(const LoginError("Something went wrong", "something_wrong"));
  //   }
  // }

  // void initLoginApple(AuthorizationCredentialAppleID credential) async {
  //   emit(const LoginLoading());
  //   try {
  //     final AuthResponseSocial loggedInResponseSocial =
  //         await _repository.signInWithApple(credential);
  //     if (loggedInResponseSocial.authResponse != null) {
  //       await LocalDataLayer()
  //           .saveAuthResponse(loggedInResponseSocial.authResponse!);
  //       emit(LoginLoaded(loggedInResponseSocial.authResponse!));
  //     } else if (loggedInResponseSocial.userEmail != null) {
  //       emit(LoginErrorSocial(
  //           loggedInResponseSocial.userName ??
  //               loggedInResponseSocial.userEmail!.split("@")[0],
  //           loggedInResponseSocial.userEmail,
  //           loggedInResponseSocial.userImageUrl,
  //           "User doesn't exist",
  //           "social_user_na"));
  //     } else {
  //       emit(const LoginError("Something went wrong", "something_wrong"));
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     emit(const LoginError("Something went wrong", "something_wrong"));
  //   }
  // }

  /// SIGNUP BELOW

  void initRegistration(String dialCode, String phoneNumber, String name,
      String email, String? pass, String? imageUrl) async {
    emit(const RegisterLoading());
    // bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
    //         phoneNumber: phoneNumber, isoCode: countryCode) ??
    //     false;
    // if (isValid) {
    // String? normalizedNumber = await PhoneNumberUtil.normalizePhoneNumber(
    //     phoneNumber: phoneNumber, isoCode: countryCode);
    // if (normalizedNumber == null) {
    //   emit(const RegisterError("Invalid phone number", "invalid_phone"));
    //   return;
    // }
    String normalizedNumber = "$dialCode$phoneNumber";
    try {
      AuthResponse registeredState = await _repository.registerUser(
          AuthRequestRegister(name, email, pass, normalizedNumber, imageUrl));
      emit(RegisterLoaded(registeredState));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      RegisterError errorState =
          const RegisterError("Something went wrong", "something_wrong");
      try {
        if (e is DioException &&
            (e).response != null &&
            (e).response!.data != null) {
          Map<String, dynamic> errorResponse = (e).response!.data;
          if (errorResponse.containsKey("errors")) {
            if ((errorResponse['errors'] as Map<String, dynamic>)
                .containsKey("email")) {
              errorState = RegisterError(
                  (errorResponse['errors']['email'] as List<dynamic>).isNotEmpty
                      ? (errorResponse['errors']['email'] as List<dynamic>)[0]
                      : "Something went wrong",
                  "err_email");
            } else if ((errorResponse['errors'] as Map<String, dynamic>)
                .containsKey("mobile_number")) {
              errorState = RegisterError(
                  (errorResponse['errors']['mobile_number'] as List<dynamic>)
                          .isNotEmpty
                      ? (errorResponse['errors']['mobile_number']
                          as List<dynamic>)[0]
                      : "Something went wrong",
                  "err_phone");
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      emit(errorState);
    }
    // } else {
    //   emit(const RegisterError("Invalid phone number", "invalid_phone"));
    // }
  }

  /// VERIFICATION BELOW

  void initAuthentication(String phoneNumberFull) async {
    Future.delayed(const Duration(milliseconds: 500),
        () => emit(const VerificationSendingLoading()));
    _repository.otpSend(phoneNumberFull, this);
  }

  void verifyOtp(String otp) async {
    if (_isOtpValid(otp)) {
      onCodeVerifying();
      await _repository.otpVerify(otp, this);
    } else {
      emit(const VerificationError("Please enter a valid otp", "otp_invalid"));
    }
  }

  @override
  void onCodeSent() {
    emit(VerificationSentLoaded());
  }

  @override
  void onCodeSendError(bool codeSent) {
    emit(VerificationError("Something went wrong",
        codeSent ? "something_wrong_verifying" : "something_wrong_sending"));
  }

  @override
  void onCodeVerifying() {
    emit(const VerificationVerifyingLoading());
  }

  @override
  void onCodeVerified(AuthResponse loggedInResponse) async {
    await LocalDataLayer().saveAuthResponse(loggedInResponse);
    emit(VerificationVerifyingLoaded(loggedInResponse));
    // DriverProfile? driverProfile;
    // try {
    //   driverProfile = await _repository
    //       .getDriverProfile("Bearer ${loggedInResponse.token}");
    //   await LocalDataLayer().saveAuthResponse(loggedInResponse);
    //   await LocalDataLayer().setSavedDriverProfile(driverProfile);
    //   emit(VerificationVerifyingLoaded(loggedInResponse));
    // } catch (e) {
    //   if (kDebugMode) {
    //     print(e);
    //   }
    //   emit(
    //       const VerificationError("Something went wrong", "profile_fetch_err"));
    // }
  }

  @override
  void onCodeVerificationError(String erroCode) {
    emit(VerificationError("Something went wrong", erroCode));
  }

  bool _isOtpValid(String otp) {
    RegExp otpPattern = RegExp('^\\d{6}\$');
    return otpPattern.hasMatch(otp);
  }
}

class RegisterData {
  String? name, email, imageUrl;
  PhoneNumberData? phoneNumberData;

  RegisterData(this.name, this.email, this.imageUrl, this.phoneNumberData);
}

class PhoneNumberData {
  String? countryText, isoCode, dialCode, phoneNumber, phoneNumberNormalised;

  PhoneNumberData(this.countryText, this.isoCode, this.dialCode,
      this.phoneNumber, this.phoneNumberNormalised);
}

abstract class VerificationCallbacks {
  void onCodeSent();

  void onCodeSendError(bool codeSent);

  void onCodeVerifying();

  void onCodeVerified(AuthResponse loggedInResponse);

  void onCodeVerificationError(String erroCode);
}
