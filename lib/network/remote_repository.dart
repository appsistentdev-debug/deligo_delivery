// ignore_for_file: deprecated_member_use

import 'dart:io';

//import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:deligo_delivery/bloc/auth_cubit.dart';
import 'package:deligo_delivery/config/app_config.dart';
import 'package:deligo_delivery/models/address.dart';
import 'package:deligo_delivery/models/address_request.dart';
import 'package:deligo_delivery/models/auth_request_check_existence.dart';
import 'package:deligo_delivery/models/auth_request_login.dart';
import 'package:deligo_delivery/models/auth_request_register.dart';
import 'package:deligo_delivery/models/auth_response.dart';
import 'package:deligo_delivery/models/order.dart';
import 'package:deligo_delivery/models/order_delivery_request.dart';
import 'package:deligo_delivery/models/send_to_bank.dart';
import 'package:deligo_delivery/models/base_list_response.dart';
import 'package:deligo_delivery/models/category.dart' as my_category;
import 'package:deligo_delivery/models/driver_profile.dart';
import 'package:deligo_delivery/models/driver_profile_update_request.dart';
import 'package:deligo_delivery/models/faq.dart';
import 'package:deligo_delivery/models/file_upload_response.dart';
import 'package:deligo_delivery/models/earning_insight.dart';
import 'package:deligo_delivery/models/notifications_summary.dart';
import 'package:deligo_delivery/models/payment.dart';
import 'package:deligo_delivery/models/payment_method.dart';
import 'package:deligo_delivery/models/payment_response.dart';
import 'package:deligo_delivery/models/rating.dart';
import 'package:deligo_delivery/models/rating_request.dart';
import 'package:deligo_delivery/models/review.dart';
import 'package:deligo_delivery/models/ride.dart';
import 'package:deligo_delivery/models/ride_summary.dart';
import 'package:deligo_delivery/models/setting.dart';
import 'package:deligo_delivery/models/support_request.dart';
import 'package:deligo_delivery/models/transaction.dart';
import 'package:deligo_delivery/models/user_data.dart';
import 'package:deligo_delivery/models/user_notification.dart';
import 'package:deligo_delivery/models/vehicle_type_response.dart';
import 'package:deligo_delivery/models/wallet.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'remote_client.dart';
import 'request_interceptor.dart';

class RemoteRepository {
  static RemoteRepository? _instance;

  final Dio dio;
  final RemoteClient client;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // final FacebookAuth _facebookAuth = FacebookAuth.instance;
  // final GoogleSignIn _googleSignIn =
  //     GoogleSignIn(scopes: <String>['email', 'profile']);
  String? _verificationId;
  int? _resendToken;

  RemoteRepository._(this.dio, this.client);

  factory RemoteRepository() {
    if (_instance == null) {
      Dio dio = Dio();
      dio.interceptors.add(RequestInterceptor());
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));
      // dio.interceptors.add(RetryInterceptor(
      //   dio: dio,
      //   logPrint: print,
      //   retries: 1,
      //   retryDelays: const [Duration(seconds: 1)],
      //   retryEvaluator: (error, attempt) =>
      //       error.type == DioExceptionType.badResponse ||
      //       error.response?.statusCode == 400,
      // ));
      RemoteClient client = RemoteClient(
        dio,
        baseUrl: AppConfig.baseUrl,
      );
      _instance = RemoteRepository._(dio, client);
    }
    return _instance!;
  }

  /// AUTH STUFF START
  Future<void> logout() async {
    await LocalDataLayer().clearPrefs();
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print("firebaseAuth.signOut: $e");
      }
    }
    // try {
    //   await _googleSignIn.signOut();
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("googleSignIn.signOut: $e");
    //   }
    // }
    // try {
    //   await _facebookAuth.logOut();
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("facebookLogin.logOut: $e");
    //   }
    // }
  }

  Future<bool> isRegistered(String number) async {
    try {
      await client.checkUser(AuthRequestCheckExistence(number));
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("isRegistered: $e");
      }
      return false;
    }
  }

  Future<AuthResponse> registerUser(AuthRequestRegister registerUser) {
    return client.registerUser(registerUser);
  }

  Future<AuthResponse> signInWithPhoneNumber(String fireToken) {
    return client.login(AuthRequestLogin(fireToken));
  }

  Future<void> otpSend(
      String phoneNumberFull, VerificationCallbacks verificationCallback) {
    _resendToken = -1;
    return _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumberFull,
      verificationCompleted: (PhoneAuthCredential credential) {
        if (Platform.isAndroid) {
          verificationCallback.onCodeVerifying();
          _fireSignIn(credential, verificationCallback);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (kDebugMode) {
          print("FirebaseAuthException: $e");
          print("FirebaseAuthException_message: ${e.message}");
          print("FirebaseAuthException_code: ${e.code}");
          print("FirebaseAuthException_phoneNumber: ${e.phoneNumber}");
        }
        verificationCallback.onCodeSendError(_resendToken != -1);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        verificationCallback.onCodeSent();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> otpVerify(
          String otp, VerificationCallbacks verificationCallback) =>
      _fireSignIn(
          PhoneAuthProvider.credential(
              verificationId: _verificationId!, smsCode: otp),
          verificationCallback);

  Future<void> _fireSignIn(AuthCredential credential,
      VerificationCallbacks verificationCallback) async {
    try {
      await _firebaseAuth.signInWithCredential(credential);
      try {
        var user = _firebaseAuth.currentUser;
        if (user == null) {
          verificationCallback.onCodeVerificationError("something_wrong");
          return;
        }
        var idToken = await user.getIdToken();

        final loggedInResponse = await signInWithPhoneNumber(idToken!);
        verificationCallback.onCodeVerified(loggedInResponse);
      } catch (e) {
        if (kDebugMode) {
          print("signInWithCredential: $e");
        }
        String errorToReturn = "something_wrong";
        if (e is DioException) {
          //signout of social accounts.
          try {
            logout();
          } catch (le) {
            if (kDebugMode) {
              print(le);
            }
          }
          if ((e).response != null && (e).response!.data != null) {
            Map<String, dynamic> errorResponse = (e).response!.data;
            if (errorResponse.containsKey("message")) {
              String errorMessage = errorResponse["message"] as String;
              if (kDebugMode) {
                print("errorMessage: $errorMessage");
              }
              if (errorMessage.toLowerCase().contains("role")) {
                errorToReturn = "role_exists";
              }
            }
          }
        }
        verificationCallback.onCodeVerificationError(errorToReturn);
      }
    } catch (e) {
      if (kDebugMode) {
        print("signInWithCredential - ${e.runtimeType}: $e");
      }
      verificationCallback.onCodeVerificationError("unable_otp_verification");
    }
  }

  // Future<AuthResponseSocial> signInWithGoogle() async {
  //   GoogleSignInAccount? googleUser;
  //   try {
  //     googleUser = await _googleSignIn.signIn();
  //     //if (googleUser == null) return AuthResponseSocial(null, null, null, null);
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;
  //     AuthResponse authResponse = await client.socialLogin(
  //         AuthRequestLoginSocial("google", googleAuth.idToken!,
  //             Platform.isAndroid ? "android" : "ios"));
  //     return AuthResponseSocial(null, null, null, authResponse);
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("signInWithGoogle");
  //       print(e);
  //     }
  //     String? userName, userEmail, userImageUrl;

  //     try {
  //       if (e is DioException) {
  //         Response<dynamic>? response = (e).response;
  //         if (response == null) {
  //           return AuthResponseSocial(null, null, null, null);
  //         }
  //         if (response.statusCode == 404 && response.data != null) {
  //           Map<String, dynamic> errorResponse = response.data;
  //           if (errorResponse.containsKey("message")) {
  //             if (errorResponse.containsKey("name")) {
  //               userName = errorResponse["name"];
  //             } else if (googleUser != null && googleUser.displayName != null) {
  //               userName = googleUser.displayName;
  //             }

  //             if (errorResponse.containsKey("email")) {
  //               userEmail = errorResponse["email"];
  //             } else if (googleUser != null) {
  //               userEmail = googleUser.email;
  //             }

  //             if (errorResponse.containsKey("image_url")) {
  //               userImageUrl = errorResponse["image_url"];
  //             } else if (googleUser != null && googleUser.photoUrl != null) {
  //               userImageUrl = googleUser.photoUrl;
  //             }
  //           }
  //         }
  //       }
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print("DioError");
  //         print(e);
  //       }
  //     }

  //     try {
  //       logout();
  //     } catch (le) {
  //       if (kDebugMode) {
  //         print(le);
  //       }
  //     }

  //     return AuthResponseSocial(userName, userEmail, userImageUrl, null);
  //   }
  // }

  // Future<AuthResponseSocial> signInWithApple(
  //     AuthorizationCredentialAppleID credentialAppleId) async {
  //   try {
  //     if (kDebugMode) {
  //       print("credentialAppleId: $credentialAppleId");
  //       print("credentialAppleId.givenName: ${credentialAppleId.givenName}");
  //       print("credentialAppleId.familyName: ${credentialAppleId.familyName}");
  //     }
  //     final credential = OAuthProvider('apple.com').credential(
  //       idToken: credentialAppleId.identityToken,
  //       accessToken: credentialAppleId.authorizationCode,
  //     );
  //     UserCredential userCredential =
  //         await _firebaseAuth.signInWithCredential(credential);
  //     if (kDebugMode) {
  //       print(userCredential);
  //     }

  //     var user = _firebaseAuth.currentUser;
  //     String token = "";
  //     if (user != null) token = (await user.getIdToken())!;
  //     if (token.isNotEmpty) {
  //       AuthResponse authResponse = await client.socialLogin(
  //           AuthRequestLoginSocial(
  //               "apple", token, Platform.isAndroid ? "android" : "ios"));
  //       return AuthResponseSocial(null, null, null, authResponse);
  //     } else {
  //       return AuthResponseSocial(null, null, null, null);
  //     }
  //   } catch (e) {
  //     String? userName, userEmail, userImageUrl;

  //     try {
  //       if (e is DioException) {
  //         Response<dynamic>? response = (e).response;
  //         if (response == null) {
  //           return AuthResponseSocial(null, null, null, null);
  //         }
  //         if (response.statusCode == 404 && response.data != null) {
  //           Map<String, dynamic> errorResponse = response.data;
  //           if (errorResponse.containsKey("message")) {
  //             if (errorResponse.containsKey("name")) {
  //               userName = errorResponse["name"];
  //             } else if (credentialAppleId.givenName != null) {
  //               userName = credentialAppleId.givenName!;
  //             }

  //             if (errorResponse.containsKey("email")) {
  //               userEmail = errorResponse["email"];
  //             } else if (credentialAppleId.email != null) {
  //               userEmail = credentialAppleId.email!;
  //             }

  //             if (errorResponse.containsKey("image_url")) {
  //               userImageUrl = errorResponse["image_url"];
  //             }
  //           }
  //         }
  //       }
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print(e);
  //       }
  //     }

  //     try {
  //       logout();
  //     } catch (le) {
  //       if (kDebugMode) {
  //         print(le);
  //       }
  //     }

  //     return AuthResponseSocial(userName, userEmail, userImageUrl, null);
  //   }
  // }

  // Future<AuthResponseSocial> signInWithFacebook() async {
  //   AccessToken? accessToken;
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status == LoginStatus.success) {
  //       accessToken = result.accessToken;
  //       if (accessToken == null) {
  //         return AuthResponseSocial(null, null, null, null);
  //       }
  //       AuthResponse authResponse = await client.socialLogin(
  //           AuthRequestLoginSocial("facebook", accessToken.token,
  //               Platform.isAndroid ? "android" : "ios"));
  //       return AuthResponseSocial(null, null, null, authResponse);
  //     } else {
  //       return AuthResponseSocial(null, null, null, null);
  //     }
  //   } catch (e) {
  //     String? userName, userEmail, userImageUrl;

  //     try {
  //       if (e is DioException) {
  //         Map<String, dynamic>? facebookUserData;
  //         if (accessToken != null) {
  //           facebookUserData = await _facebookAuth.getUserData();
  //         }
  //         Response<dynamic>? response = (e).response;
  //         if (response == null) {
  //           return AuthResponseSocial(null, null, null, null);
  //         }
  //         if (response.statusCode == 404 && response.data != null) {
  //           Map<String, dynamic> errorResponse = response.data;
  //           if (errorResponse.containsKey("message")) {
  //             if (errorResponse.containsKey("name")) {
  //               userName = errorResponse["name"];
  //             } else if (facebookUserData != null) {
  //               userName = facebookUserData["name"];
  //             }

  //             if (errorResponse.containsKey("email")) {
  //               userEmail = errorResponse["email"];
  //             } else if (facebookUserData != null) {
  //               userEmail = facebookUserData["email"];
  //             }

  //             if (errorResponse.containsKey("image_url")) {
  //               userImageUrl = errorResponse["image_url"];
  //             } else if (facebookUserData != null) {
  //               userImageUrl = facebookUserData["picture"]["data"]["url"];
  //             }
  //           }
  //         }
  //       }
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print(e);
  //       }
  //     }

  //     try {
  //       logout();
  //     } catch (le) {
  //       if (kDebugMode) {
  //         print(le);
  //       }
  //     }

  //     return AuthResponseSocial(userName, userEmail, userImageUrl, null);
  //   }
  // }

  /// AUTH STUFF END

  Future<void> postUrl(String url) => dio.post(url, data: {});

  Future<void> getUrl(String url) => dio.get(url);

  Future<List<Faq>> getFaqs() => client.getFaqs();

  Future<List<my_category.Category>> getCategoriesParent() =>
      client.getCategoriesParent();

  Future<List<my_category.Category>> getCategoriesAll() =>
      client.getCategoriesAll();

  Future<List<my_category.Category>> getCategoriesChild(
          String parentCatIdsCommaSeparated) =>
      client.getCategoriesChild(parentCatIdsCommaSeparated);

  Future<List<my_category.Category>> getCategoriesSearch(String query) =>
      client.getCategoriesSearch(query);

  Future<List<PaymentMethod>> getPaymentMethod() => client.paymentMethods();

  Future<List<Setting>> fetchSettings() => client.getSettings();

  Future<UserData?> updateUser(Map<String, dynamic> updateRequest) async {
    updateRequest.removeWhere((key, value) => value == null);
    String? token = await LocalDataLayer().getAuthenticationToken();
    if (token == null || updateRequest.isEmpty) return null;
    return client.updateUser(token, updateRequest);
  }

  Future<UserData?> getUser() async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    if (token == null) return null;
    return client.getUser(token);
  }

  Future<Payment> depositWallet(String amount, String paymentMethodSlug) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.depositWallet(
        token, {"amount": amount, "payment_method_slug": paymentMethodSlug});
  }

  Future<PaymentResponse> payThroughStripe(
      int paymentId, String stripeToken) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.payThroughStripe(token, paymentId.toString(), stripeToken);
  }

  Future<PaymentResponse> payThroughWallet(int paymentId) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.payThroughWallet(token, paymentId.toString());
  }

  Future<void> sendToBank(SendToBank sendToBank) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.sendToBank(token, sendToBank);
  }

  Future<Wallet> balanceWallet() async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.balanceWallet(token);
  }

  Future<BaseListResponse<Transaction>> transactionsWallet(int pageNo) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.transactionsWallet(token, pageNo);
  }

  Future<EarningInsight> fetchInsights(
      Map<String, String> insightRequest) async {
    String? token = await LocalDataLayer().getAuthenticationToken();

    return client.fetchInsights(
        token, insightRequest["duration"]!, insightRequest["limit"]!);
  }

  Future<VehicleTypeResponse> getVehicleTypes() async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getVehicleTypes(token);
  }

  Future<DriverProfile> getProfile() async {
    String? rm = (await LocalDataLayer().getProfileMode())?.riding_mode;
    return rm == "delivery"
        ? await getDeliveryProfile(null)
        : await getDriverProfile(null);
  }

  Future<DriverProfile> getDriverProfile(String? token) async {
    String? tokenToUse =
        token ?? (await LocalDataLayer().getAuthenticationToken());
    return client.getDriverProfile(tokenToUse);
  }

  Future<DriverProfile> getDeliveryProfile(String? token) async {
    String? tokenToUse =
        token ?? (await LocalDataLayer().getAuthenticationToken());
    return client.getDeliveryProfile(tokenToUse);
  }

  Future<DriverProfile> updateDriverProfile(
      DriverProfileUpdateRequest driverProfileUpdateRequest) async {
    Map<String, dynamic> driverProfileUpdateRequestMap =
        driverProfileUpdateRequest.toJson();
    driverProfileUpdateRequestMap.removeWhere((key, value) => value == null);
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.updateDriverProfile(token, driverProfileUpdateRequestMap);
  }

  Future<DriverProfile> updateDeliveryProfile(int deliveryProfileId,
      DriverProfileUpdateRequest driverProfileUpdateRequest) async {
    Map<String, dynamic> driverProfileUpdateRequestMap =
        driverProfileUpdateRequest.toJson();
    driverProfileUpdateRequestMap.removeWhere((key, value) => value == null);
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.updateDeliveryProfile(
        token, deliveryProfileId, driverProfileUpdateRequestMap);
  }

  Future<Rating> getProfileRating(int profileId) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getProfileRating(token, profileId);
  }

  Future<BaseListResponse<Review>> getProfileReviews(
      int proId, int pageNo) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getProfileReviews(token, proId, pageNo);
  }

  Future<RideSummary> getRideSummary(
      int id, Map<String, String> insightRequest) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getRideSummary(
        token, id, insightRequest["duration"]!, insightRequest["limit"]!);
  }

  Future<RideSummary> getOrderSummary(
      int id, Map<String, String> insightRequest) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getOrderSummary(
        token, id, insightRequest["duration"]!, insightRequest["limit"]!);
  }

  Future<BaseListResponse<UserNotification>> getUserNotifications(
      int pageNo) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getUserNotifications(token, pageNo);
  }

  Future<List<Address>> fetchAddresses() async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getAddresses(token);
  }

  Future<dynamic> createRating(
      int providerId, RatingRequest ratingRequest) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.createRating(token, providerId, ratingRequest);
  }

  Future<Address> createAddress(AddressRequest addressRequest) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.createAddress(token, addressRequest);
  }

  Future<Address> updateAddress(
      int addressId, AddressRequest addressRequest) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.updateAddress(token, addressId, addressRequest);
  }

  Future<void> deleteAddress(int addressId) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.deleteAddress(token, addressId);
  }

  Future<dynamic> postSupport(SupportRequest supportRequest) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.postSupport(token, supportRequest);
  }

  Future<void> postNotification(
      {required String roleTo,
      required String userIdTo,
      String? title,
      String? body}) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.postNotification(
        token, {"role": roleTo, "user_id": userIdTo}, title, body);
  }

  Future<NotificationsSummary> fetchNotificationsSummary() async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getNotificationsSummary(token);
  }

  Future<dynamic> postNotificationsRead() async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.postNotificationsRead(token);
  }

  Future<void> deleteUser() async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    await client.deleteUser(token);
  }

  Future<BaseListResponse<Ride>> getRides(int driverId, int pageNo) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getRides(token, driverId, pageNo, 1);
  }

  Future<Ride> updateRide(int rideId, String status) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.updateRide(token, rideId, {"status": status});
  }

  Future<Order> getCurrentOrder(int profileId) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getCurrentOrder(token, profileId);
  }

  Future<OrderDeliveryRequest> getDeliveryRequest(int profileId) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getDeliveryRequest(token, profileId);
  }

  Future<void> updateDeliveryRequest(
      int profileId, int requestId, String status) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.updateDeliveryRequest(token, requestId, {"status": status});
  }

  Future<Order> updateDeliveryOrder(
      int orderId, Map<String, String> updateOrderRequest) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.updateDeliveryOrder(token, orderId, updateOrderRequest);
  }

  Future<Order> getOrderById(int orderId) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getOrderById(token, orderId);
  }

  Future<FileUploadResponse> uploadFile(File file) =>
      client.uploadFile(file: file);
}
