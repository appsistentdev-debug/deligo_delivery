import 'dart:io';

import 'package:deligo_delivery/models/order_delivery_request.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:deligo_delivery/models/address.dart';
import 'package:deligo_delivery/models/address_request.dart';
import 'package:deligo_delivery/models/auth_request_check_existence.dart';
import 'package:deligo_delivery/models/auth_request_login.dart';
import 'package:deligo_delivery/models/auth_request_login_social.dart';
import 'package:deligo_delivery/models/auth_request_register.dart';
import 'package:deligo_delivery/models/auth_response.dart';
import 'package:deligo_delivery/models/base_list_response.dart';
import 'package:deligo_delivery/models/category.dart';
import 'package:deligo_delivery/models/driver_profile.dart';
import 'package:deligo_delivery/models/earning_insight.dart';
import 'package:deligo_delivery/models/faq.dart';
import 'package:deligo_delivery/models/file_upload_response.dart';
import 'package:deligo_delivery/models/notifications_summary.dart';
import 'package:deligo_delivery/models/order.dart';
import 'package:deligo_delivery/models/payment.dart';
import 'package:deligo_delivery/models/payment_method.dart';
import 'package:deligo_delivery/models/payment_response.dart';
import 'package:deligo_delivery/models/rating.dart';
import 'package:deligo_delivery/models/rating_request.dart';
import 'package:deligo_delivery/models/review.dart';
import 'package:deligo_delivery/models/ride.dart';
import 'package:deligo_delivery/models/ride_summary.dart';
import 'package:deligo_delivery/models/send_to_bank.dart';
import 'package:deligo_delivery/models/setting.dart';
import 'package:deligo_delivery/models/support_request.dart';
import 'package:deligo_delivery/models/transaction.dart';
import 'package:deligo_delivery/models/user_data.dart';
import 'package:deligo_delivery/models/user_notification.dart';
import 'package:deligo_delivery/models/vehicle_type_response.dart';
import 'package:deligo_delivery/models/wallet.dart';

part 'remote_client.g.dart';

@RestApi()
abstract class RemoteClient {
  factory RemoteClient(Dio dio, {String? baseUrl}) = _RemoteClient;

  @POST("api/check-user")
  Future<void> checkUser(@Body() AuthRequestCheckExistence checkUser);

  @POST("api/register")
  Future<AuthResponse> registerUser(
      @Body() AuthRequestRegister authRequestRegister);

  @POST("api/login")
  Future<AuthResponse> login(@Body() AuthRequestLogin loginRequest);

  @POST("api/social/login")
  Future<AuthResponse> socialLogin(
      @Body() AuthRequestLoginSocial socialLoginUser);

  @POST("api/support")
  Future<void> createSupport(@Body() SupportRequest support);

  @PUT("api/user")
  Future<UserData> updateUser(@Header("Authorization") String bearerToken,
      @Body() Map<String, dynamic> updateUserRequest);

  @GET("api/user")
  Future<UserData> getUser(@Header("Authorization") String bearerToken);

  @GET("api/settings")
  Future<List<Setting>> getSettings();

  @GET("api/banners?pagination=0")
  Future<List<Category>> getBanners();

  @GET("api/categories?pagination=0&parent=1")
  Future<List<Category>> getCategoriesParent();

  @GET("api/categories?pagination=0")
  Future<List<Category>> getCategoriesAll();

  @GET("api/categories?pagination=0")
  Future<List<Category>> getCategoriesChild(
      @Query("categories") String parentCatIdsCommaSeparated);

  @GET("api/categories?pagination=0")
  Future<List<Category>> getCategoriesSearch(@Query("title") String title);

  @GET("api/faq")
  Future<List<Faq>> getFaqs();

  @GET("api/user/addresses")
  Future<List<Address>> getAddresses(
      @Header("Authorization") String? bearerToken);

  @POST("api/user/addresses")
  Future<Address> createAddress(@Header("Authorization") String? bearerToken,
      @Body() AddressRequest addressRequest);

  @POST("api/provider/profile/ratings/{providerId}")
  Future<dynamic> createRating(@Header("Authorization") String? bearerToken,
      @Path("providerId") int providerId, @Body() RatingRequest ratingRequest);

  @PUT("api/user/addresses/{addressId}")
  Future<Address> updateAddress(@Header("Authorization") String? bearerToken,
      @Path("addressId") int addressId, @Body() AddressRequest addressRequest);

  @DELETE("api/user/addresses/{addressId}")
  Future<void> deleteAddress(@Header("Authorization") String? bearerToken,
      @Path("addressId") int addressId);

  @POST("api/support")
  Future<dynamic> postSupport(@Header("Authorization") String? bearerToken,
      @Body() SupportRequest supportRequest);

  @GET("api/user/notifications")
  Future<BaseListResponse<UserNotification>> getUserNotifications(
      @Header("Authorization") String? bearerToken, @Query("page") int pageNo);

  @GET("api/payment/methods")
  Future<List<PaymentMethod>> paymentMethods();

  @GET("api/user/wallet/balance")
  Future<Wallet> balanceWallet(@Header("Authorization") String? bearerToken);

  @POST("api/user/wallet/deposit")
  Future<Payment> depositWallet(@Header("Authorization") String? bearerToken,
      @Body() Map<String, String> map);

  @POST('api/user/wallet/payout')
  Future<void> sendToBank(@Header("Authorization") String? bearerToken,
      @Body() SendToBank sendToBank);

  @GET("api/payment/wallet/{paymentId}")
  Future<PaymentResponse> payThroughWallet(
      @Header("Authorization") String? bearerToken,
      @Path("paymentId") String paymentId);

  @GET('api/user/wallet/transactions')
  Future<BaseListResponse<Transaction>> transactionsWallet(
      @Header("Authorization") String? bearerToken, @Query("page") int pageNo);

  @GET('api/user/wallet/earnings')
  Future<EarningInsight> fetchInsights(
    @Header("Authorization") String? bearerToken,
    @Query('duration') String duration,
    @Query('limit') String limit,
  );

  @GET("api/payment/stripe/{paymentId}")
  Future<PaymentResponse> payThroughStripe(
      @Header("Authorization") String? bearerToken,
      @Path("paymentId") String paymentId,
      @Query("token") String stripeToken);

  @POST("api/user/push-notification")
  Future<void> postNotification(
      @Header("Authorization") String? bearerToken,
      @Body() Map<String, dynamic> notiData,
      @Query("message_title") String? messageTitle,
      @Query("message_body") String? messageBody);

  @GET("api/user/notifications/summary")
  Future<NotificationsSummary> getNotificationsSummary(
      @Header("Authorization") String? bearerToken);

  @POST("api/user/notifications/read")
  Future<dynamic> postNotificationsRead(
      @Header("Authorization") String? bearerToken);

  @DELETE("api/user")
  Future<void> deleteUser(@Header("Authorization") String? bearerToken);

  @GET("api/ride/drivers")
  Future<DriverProfile> getDriverProfile(
      @Header("Authorization") String? bearerToken);

  @GET("api/delivery")
  Future<DriverProfile> getDeliveryProfile(
      @Header("Authorization") String? bearerToken);

  @PUT("api/ride/drivers")
  Future<DriverProfile> updateDriverProfile(
      @Header("Authorization") String? bearerToken,
      @Body() Map<String, dynamic> driverProfileUpdateRequest);

  @PUT("api/delivery/{deliveryProfileId}")
  Future<DriverProfile> updateDeliveryProfile(
      @Header("Authorization") String? bearerToken,
      @Path("deliveryProfileId") int deliveryProfileId,
      @Body() Map<String, dynamic> driverProfileUpdateRequest);

  @GET("api/ride/vehicle-types")
  Future<VehicleTypeResponse> getVehicleTypes(
    @Header("Authorization") String? bearerToken, {
    @Query("latitude_from") String? latitudeFrom,
    @Query("longitude_from") String? longitudeFrom,
    @Query("latitude_to") String? latitudeTo,
    @Query("longitude_to") String? longitudeTo,
  });

  @GET('api/ride/drivers/ratings/summary/{providerId}')
  Future<Rating> getProfileRating(@Header("Authorization") String? bearerToken,
      @Path("providerId") int providerId);

  @GET('api/ride/drivers/ratings/{providerId}')
  Future<BaseListResponse<Review>> getProfileReviews(
      @Header("Authorization") String? bearerToken,
      @Path("providerId") int providerId,
      @Query("page") int pageNo);

  @GET('api/ride/drivers/{id}/summary')
  Future<RideSummary> getRideSummary(
      @Header("Authorization") String? bearerToken,
      @Path('id') int id,
      @Query('duration') String duration,
      @Query('limit') String limit);

  @GET('api/delivery/{id}/summary')
  Future<RideSummary> getOrderSummary(
      @Header("Authorization") String? bearerToken,
      @Path('id') int id,
      @Query('duration') String duration,
      @Query('limit') String limit);

  @GET('api/ride/rides')
  Future<BaseListResponse<Ride>> getRides(
      @Header("Authorization") String? bearerToken,
      @Query("driver") int driverId,
      @Query("page") int pageNo,
      @Query("upcoming") int? upcoming);

  @PUT("api/ride/rides/{rideId}")
  Future<Ride> updateRide(
      @Header("Authorization") String? bearerToken,
      @Path("rideId") int rideId,
      @Body() Map<String, dynamic> updateRideRequest);

  @GET('api/delivery/{profileId}/order')
  Future<Order> getCurrentOrder(@Header("Authorization") String? bearerToken,
      @Path("profileId") int profileId);

  @GET('api/delivery/{profileId}/request?status=pending')
  Future<OrderDeliveryRequest> getDeliveryRequest(
      @Header("Authorization") String? bearerToken,
      @Path("profileId") int profileId);

  @PUT('api/delivery/request/{requestId}')
  Future<void> updateDeliveryRequest(
      @Header("Authorization") String? bearerToken,
      @Path("requestId") int requestId,
      @Body() Map<String, dynamic> updateRequest);

  @PUT('api/orders/{orderId}')
  Future<Order> updateDeliveryOrder(
      @Header("Authorization") String? bearerToken,
      @Path('orderId') int orderId,
      @Body() Map<String, String> updateOrder);

  @GET('api/orders/{id}')
  Future<Order> getOrderById(
      @Header("Authorization") String? bearerToken, @Path('id') int orderId);

  @POST("api/file-upload")
  @MultiPart()
  Future<FileUploadResponse> uploadFile({@Part() File? file});
}
