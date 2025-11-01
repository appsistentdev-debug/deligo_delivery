import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart' as fire_db;
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart'
    as places;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:deligo_delivery/models/address.dart';
import 'package:deligo_delivery/models/address_request.dart';
import 'package:deligo_delivery/models/base_list_response.dart';
import 'package:deligo_delivery/models/category.dart' as my_category;
import 'package:deligo_delivery/models/driver_profile.dart';
import 'package:deligo_delivery/models/driver_profile_update_request.dart';
import 'package:deligo_delivery/models/earning_insight.dart';
import 'package:deligo_delivery/models/faq.dart';
import 'package:deligo_delivery/models/order.dart';
import 'package:deligo_delivery/models/order_delivery_request.dart';
import 'package:deligo_delivery/models/profile_mode.dart';
import 'package:deligo_delivery/models/rating.dart';
import 'package:deligo_delivery/models/rating_summary.dart';
import 'package:deligo_delivery/models/review.dart';
import 'package:deligo_delivery/models/ride.dart';
import 'package:deligo_delivery/models/ride_summary.dart';
import 'package:deligo_delivery/models/send_to_bank.dart';
import 'package:deligo_delivery/models/support_request.dart';
import 'package:deligo_delivery/models/transaction.dart';
import 'package:deligo_delivery/models/update_user_request.dart';
import 'package:deligo_delivery/models/user_data.dart';
import 'package:deligo_delivery/models/user_notification.dart';
import 'package:deligo_delivery/models/vehicle_type.dart';
import 'package:deligo_delivery/models/vehicle_type_fare.dart';
import 'package:deligo_delivery/models/vehicle_type_response.dart';
import 'package:deligo_delivery/models/wallet.dart';
import 'package:deligo_delivery/network/map_repository.dart';
import 'package:deligo_delivery/network/remote_repository.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';

part 'fetcher_state.dart';

class FetcherCubit extends Cubit<FetcherState> {
  final RemoteRepository _repository = RemoteRepository();
  StreamSubscription<fire_db.DatabaseEvent>? _rideRequestStream,
      _rideStream,
      _orderRequestStream;

  FetcherCubit() : super(const FetcherInitial());

  Future<void> initGetUserMe(bool forceReload) async {
    emit(const UserMeLoading());
    if (forceReload) {
      try {
        UserData? freshUser = await _repository.getUser();
        if (freshUser != null) {
          await LocalDataLayer().setUserMe(freshUser);
          emit(UserMeLoaded(freshUser));
        } else {
          emit(UserMeError("Something went wrong", "something_wrong"));
        }
      } catch (e) {
        if (kDebugMode) {
          print("initGetUserMe: $e");
        }
        emit(UserMeError(_getErrorMessage(e), "something_wrong"));
      }
    } else {
      UserData? savedUser = await LocalDataLayer().getUserMe();
      emit(savedUser != null
          ? UserMeLoaded(savedUser)
          : UserMeError("Unauthenticated", "unauthenticated"));
    }
  }

  Future<void> initUpdateUserMe(String? name, String? imageUrl) async {
    emit(const UserMeUpdating());
    try {
      UserData? updatedUser = await _repository
          .updateUser(UpdateUserRequest(name, imageUrl).toJson());
      if (updatedUser != null) {
        await LocalDataLayer().setUserMe(updatedUser);
        emit(UserMeLoaded(updatedUser));
      } else {
        emit(UserMeError("Something went wrong", "something_wrong"));
      }
    } catch (e) {
      if (kDebugMode) {
        print("initUpdateUserMe: $e");
      }
      emit(UserMeError(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initSupportSubmit(String supportMsg) async {
    emit(const SupportLoading());
    try {
      UserData? userData = await LocalDataLayer().getUserMe();
      await _repository.postSupport(
          SupportRequest(userData!.name, userData.email, supportMsg));
      emit(const SupportLoaded());
    } catch (e) {
      if (kDebugMode) {
        print("initSupportSubmit: $e");
      }
      emit(SupportLoadFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchFaqs() async {
    emit(const FaqLoading());
    try {
      List<Faq> faqs = await _repository.getFaqs();
      emit(FaqLoaded(faqs));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchFaqs: $e");
      }
      emit(FaqLoadFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchCategoriesParent() async {
    emit(const CategoriesLoading());
    try {
      List<my_category.Category> categories =
          await _repository.getCategoriesParent();
      for (my_category.Category category in categories) {
        category.setupImageUrl();
      }
      emit(CategoriesLoaded(categories));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchCategoriesParent: $e");
      }
      emit(CategoriesFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchCategoriesChild(int parentCatId) async {
    emit(const CategoriesLoading());
    try {
      List<my_category.Category> categories = parentCatId == -1
          ? await _repository.getCategoriesAll()
          : await _repository.getCategoriesChild("$parentCatId");
      for (my_category.Category category in categories) {
        category.setupImageUrl();
      }
      emit(CategoriesLoaded(categories));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchCategoriesParent: $e");
      }
      emit(CategoriesFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchCategoriesSearch(String query) async {
    emit(const CategoriesLoading());
    try {
      List<my_category.Category> categories =
          await _repository.getCategoriesSearch(query);
      for (my_category.Category category in categories) {
        category.setupImageUrl();
      }
      emit(CategoriesLoaded(categories));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchCategoriesSearch: $e");
      }
      emit(CategoriesFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchNotifications(int pageNo) async {
    emit(const UserNotificationsLoading());
    try {
      BaseListResponse<UserNotification> notifications =
          await _repository.getUserNotifications(pageNo);
      for (UserNotification notification in notifications.data) {
        notification.setup();
      }
      emit(UserNotificationsLoaded(notifications));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchProviderReviews: $e");
      }
      emit(UserNotificationsFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchAddresses() async {
    emit(const AddressesLoading());
    try {
      List<Address> addresses = await _repository.fetchAddresses();
      emit(AddressesLoaded(addresses));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchAddresses: $e");
      }
      emit(AddressesLoadFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initCreateAddress(AddressRequest addressRequest) async {
    emit(const AddressAddLoading());
    try {
      Address address = await _repository.createAddress(addressRequest);
      emit(AddressAddLoaded(address));
    } catch (e) {
      if (kDebugMode) {
        print("initCreateAddress: $e");
      }
      emit(AddressAddFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initUpdateAddress(
      int addressId, AddressRequest addressRequest) async {
    emit(const AddressUpdateLoading());
    try {
      Address address =
          await _repository.updateAddress(addressId, addressRequest);
      emit(AddressUpdateLoaded(address));
    } catch (e) {
      if (kDebugMode) {
        print("initUpdateAddress: $e");
      }
      emit(AddressUpdateFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initDeleteAddress(int addressId) async {
    emit(const AddressDeleteLoading());
    try {
      await _repository.deleteAddress(addressId);
      emit(AddressDeleteLoaded(addressId));
    } catch (e) {
      if (kDebugMode) {
        print("initDeleteAddress: $e");
      }
      emit(AddressDeleteFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchLatLngAddress(LatLng latLng) async {
    emit(const ReverseGeocodeLoading());
    try {
      String address = await MapRepository().getAddress(latLng, true);
      emit(ReverseGeocodeLoaded(address, latLng));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchLatLngAddress: $e");
      }
      emit(ReverseGeocodeFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchPredictionAddress(places.Prediction prediction) async {
    emit(const GeocodeLoading());
    try {
      MapRepository mapRepository = MapRepository();
      places.PlaceDetails placeDetails =
          await mapRepository.getPlaceDetails(prediction.placeId!);
      LatLng latLng = LatLng(placeDetails.geometry!.location.lat,
          placeDetails.geometry!.location.lng);
      String address = "";
      try {
        address = await mapRepository.getAddress(latLng, true);
      } catch (e) {
        address = placeDetails.formattedAddress ?? "";
        if (kDebugMode) {
          print("getAddress: $e");
        }
      }
      emit(GeocodeLoaded(address, latLng));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchPredictionAddress: $e");
      }
      emit(GeocodeFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchProviderReviews(int pageNo) async {
    emit(const ReviewsLoading());
    try {
      ProfileMode profileMode = (await LocalDataLayer().getProfileMode())!;
      BaseListResponse<Review> reviews = await _repository.getProfileReviews(
          profileMode.driver_profile_id!, pageNo);
      for (Review review in reviews.data) {
        review.setup();
      }
      emit(ReviewsLoaded(reviews));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchProviderReviews: $e");
      }
      emit(ReviewsFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<DriverProfile?> initFetchProfileMe({
    bool forceFresh = true,
    String? ridingMode,
  }) async {
    emit(const ProfileMeLoading());
    try {
      //if (!forceFresh) {
      DriverProfile? providerProfileSaved =
          await LocalDataLayer().getSavedDriverProfile();
      if (providerProfileSaved != null) {
        providerProfileSaved.setup();
        emit(ProfileMeLoaded(providerProfileSaved, ridingMode));
      }
      if (providerProfileSaved != null && !forceFresh) {
        return providerProfileSaved;
      }
      //}
      String? rm =
          ridingMode ?? (await LocalDataLayer().getProfileMode())?.riding_mode;
      DriverProfile providerProfile = rm == "delivery"
          ? await _repository.getDeliveryProfile(null)
          : await _repository.getDriverProfile(null);

      if (ridingMode == null) {
        LocalDataLayer().setSavedDriverProfile(providerProfile);
      }
      //if (emitStates) emit(ProfileMeLoading());
      providerProfile.setup();
      emit(ProfileMeLoaded(providerProfile, ridingMode));
      return providerProfile;
    } catch (e) {
      if (kDebugMode) {
        print("initFetchProfileMe: $e");
      }
      emit(ProfileMeFail(_getErrorMessage(e), "something_wrong"));
      return null;
    }
  }

  Future<DriverProfile?> initUpdateProfileMe(
    DriverProfileUpdateRequest driverProfileUpdateRequest, {
    String? userName,
    String? userImage,
    String? ridingMode,
    bool markOtherOffline = false,
  }) async {
    emit(const ProfileMeUpdateLoading());
    try {
      //update user first
      try {
        await _repository
            .updateUser({"name": userName, "image_url": userImage});
      } catch (e) {
        if (kDebugMode) {
          print("initUpdateProfileMeInner: $e");
        }
      }

      if (ridingMode != null) {
        await LocalDataLayer().setProfileMode(
            (await LocalDataLayer().getProfileMode())!
                .copyWith(riding_mode: ridingMode));
      }

      ProfileMode? pm = await LocalDataLayer().getProfileMode();
      String rm = ridingMode ?? pm!.riding_mode!;

      //update driver/delivery profile according to riding mode
      DriverProfile providerProfile = rm == "delivery"
          ? await _repository.updateDeliveryProfile(
              pm!.delivery_profile_id!, driverProfileUpdateRequest)
          : await _repository.updateDriverProfile(driverProfileUpdateRequest);

      //mark other driver/delivery offline and set same meta
      if (markOtherOffline) {
        try {
          DriverProfileUpdateRequest offlineReq = DriverProfileUpdateRequest(
            is_online: 0,
            meta: driverProfileUpdateRequest.meta,
          );
          if (rm == "delivery") {
            await _repository.updateDriverProfile(offlineReq);
          } else {
            await _repository.updateDeliveryProfile(
                (await LocalDataLayer().getProfileMode())!.delivery_profile_id!,
                offlineReq);
          }
        } catch (e) {
          if (kDebugMode) {
            print("otherOfflineReq: $e");
          }
        }
      }

      await LocalDataLayer().setSavedDriverProfile(providerProfile);
      providerProfile.setup();
      emit(ProfileMeUpdateLoaded(providerProfile));
      if (driverProfileUpdateRequest.current_latitude != null &&
          driverProfileUpdateRequest.current_longitude != null) {
        try {
          await fire_db.FirebaseDatabase.instance
              .ref()
              .child("fire_app/drivers/${providerProfile.id}/location")
              .set({
            "current_latitude": driverProfileUpdateRequest.current_latitude,
            "current_longitude": driverProfileUpdateRequest.current_longitude
          });
        } catch (e) {
          if (kDebugMode) {
            print("fireLocUpdate: $e");
          }
        }
      }
      return providerProfile;
    } catch (e) {
      if (kDebugMode) {
        print("initUpdateProfileMe: $e");
      }
      emit(ProfileMeUpdateFail(_getErrorMessage(e), "something_wrong"));
      return null;
    }
  }

  Future<void> initFetchVehicleTypes() async {
    emit(const VehicleTypeLoading());
    try {
      VehicleTypeResponse vehicleTypeResponse =
          await _repository.getVehicleTypes();
      for (VehicleType vt in vehicleTypeResponse.vehicle_types) {
        for (VehicleTypeFare vtf in vehicleTypeResponse.fares) {
          if (vtf.vehicle_type_id == vt.id) {
            vt.estimated_fare_subtotal = vtf.estimated_fare_subtotal;
            break;
          }
        }
      }
      emit(VehicleTypeLoaded(vehicleTypeResponse.vehicle_types));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchVehicleTypes: $e");
      }
      emit(VehicleTypeFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchWalletBalance() async {
    emit(const WalletBalanceLoading());
    try {
      Wallet wallet = await _repository.balanceWallet();
      emit(WalletBalanceLoaded(wallet));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchWalletBalance: $e");
      }
      emit(WalletBalanceFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchWalletTransactions(int pageNo) async {
    emit(const WalletTransactionsLoading());
    try {
      BaseListResponse<Transaction> notifications =
          await _repository.transactionsWallet(pageNo);
      for (Transaction wt in notifications.data) {
        wt.setup();
      }
      emit(WalletTransactionsLoaded(notifications));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchWalletTransactions: $e");
      }
      emit(WalletTransactionsFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initSendToBank(SendToBank sendToBank) async {
    emit(const SendtoBankLoading());
    try {
      await _repository.sendToBank(sendToBank);
      emit(const SendtoBankLoaded());
    } catch (e) {
      if (kDebugMode) {
        print("sendToBank: $e");
      }
      emit(SendtoBankFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchRideInsight(String duration) async {
    emit(const RideSummaryLoading());
    try {
      ProfileMode profileMode = (await LocalDataLayer().getProfileMode())!;
      RideSummary ri = profileMode.riding_mode == "delivery"
          ? await _repository.getOrderSummary(profileMode.delivery_profile_id!,
              RideSummary.getRequest(duration))
          : await _repository.getRideSummary(
              profileMode.driver_profile_id!, RideSummary.getRequest(duration));
      emit(RideSummaryLoaded(ri));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchWalletBalance: $e");
      }
      emit(RideSummaryFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchRideEarnings(String duration) async {
    emit(LoadingEarningInsightState(duration));
    try {
      EarningInsight earningInsight =
          await _repository.fetchInsights(EarningInsight.getRequest(duration));
      emit(LoadedEarningInsightState(earningInsight));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchRideEarnings: $e");
      }
      emit(LoadedEarningInsightState(EarningInsight.getDefault()));
    }
  }

  Future<void> initFetchProfileRating() async {
    emit(const InsightLoading());
    try {
      ProfileMode profileMode = (await LocalDataLayer().getProfileMode())!;
      Rating rating =
          await _repository.getProfileRating(profileMode.driver_profile_id!);
      List<RatingSummary> summaryList = [];
      if (rating.totalRatings == null || rating.totalRatings == 0) return;
      for (int i = 5; i >= 1; i--) {
        RatingSummary summary;
        if (rating.summary.any((element) => element.roundedRating == i)) {
          summary = rating.summary
              .firstWhere((element) => element.roundedRating == i);
          summary.percent = (summary.total / rating.totalRatings!) * 100;
        } else {
          summary = RatingSummary(0, 0);
        }
        summary.color = RatingSummary.pieChartColors[i - 1];
        summaryList.add(summary);
      }
      rating.summary = summaryList;
      emit(InsightLoaded(rating));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchProfileRating: $e");
      }
      emit(InsightFailed(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initUpdateRide(int rideId, int riderId, String status) async {
    emit(const RideUpdateLoading());
    try {
      if (status == "rejected") {
        try {
          await fire_db.FirebaseDatabase.instance
              .ref()
              .child("fire_app/drivers/$riderId/rides/$rideId")
              .remove();
        } catch (e) {
          if (kDebugMode) {
            print("initUpdateFireRide: $e");
          }
        }
      }
      Ride ride = await _repository.updateRide(rideId, status);
      ride.setup();
      emit(RideUpdateLoaded(ride, status));
    } catch (e) {
      if (kDebugMode) {
        print("initUpdateRide: $e");
      }
      emit(RideUpdateFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  Future<void> initFetchCurrentRideOrRequest() async {
    emit(const RideOrRequestLoading());
    try {
      ProfileMode profileMode = (await LocalDataLayer().getProfileMode())!;
      if (profileMode.riding_mode == "delivery") {
        await unRegisterRideRequestUpdates();
      } else {
        await unRegisterOrderRequestUpdates();
      }

      if (profileMode.riding_mode == "delivery") {
        Order? orderData;
        OrderDeliveryRequest? deliveryRequest;

        try {
          //from local
          // String sampleOrder =
          //     await rootBundle.loadString('assets/sample_order.json');
          // orderData = Order.fromJson(jsonDecode(sampleOrder));
          //from api
          orderData = await _repository
              .getCurrentOrder(profileMode.delivery_profile_id!);
          orderData.setup();
        } catch (e) {
          if (kDebugMode) {
            print("getCurrentOrder: $e");
          }
        }

        if (orderData != null) {
          emit(OrderOrRequestLoaded(orderData, null));
        } else {
          try {
            //from local
            // String sampleDeliveryRequest =
            //     await rootBundle.loadString('assets/sample_delivery_request.json');
            // deliveryRequest =
            //     GetDeliveryRequest.fromJson(jsonDecode(sampleDeliveryRequest));
            // yield SuccessDeliveryRequestState(deliveryRequest);
            //from api
            deliveryRequest = await _repository
                .getDeliveryRequest(profileMode.delivery_profile_id!);
            deliveryRequest.order?.setup();
            emit(OrderOrRequestLoaded(null, deliveryRequest));
          } catch (e) {
            if (kDebugMode) {
              print("getDeliveryRequest: $e");
            }
          }
        }

        if (deliveryRequest == null && orderData == null) {
          registerOrderRequestUpdates();
        }
      } else {
        Ride? rideCurrent, rideRequest;
        //from local
        // String sampleRide =
        //     await rootBundle.loadString('assets/sample_ride.json');
        // rideCurrent = Ride.fromJson(jsonDecode(sampleRide));
        // rideCurrent.setup();
        // emit(RideOrRequestLoaded(rideCurrent, false));
        //from api
        BaseListResponse<Ride> ridesUpcoming =
            await _repository.getRides(profileMode.driver_profile_id!, 1);
        for (Ride ru in ridesUpcoming.data) {
          if (ru.isOngoing) {
            rideCurrent = ru;
            break;
          }
        }
        if (rideCurrent != null) {
          rideCurrent.setup();
          emit(RideOrRequestLoaded(rideCurrent, false));
        } else {
          for (Ride ru in ridesUpcoming.data) {
            if (ru.isRequest) {
              rideRequest = ru;
              break;
            }
          }
          if (rideRequest != null) {
            rideRequest.setup();
            emit(RideOrRequestLoaded(rideRequest, true));
          }
        }
        if (rideCurrent == null && rideRequest == null) {
          registerRideRequestUpdates();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("initFetchCurrentRideOrRequest: $e");
      }
      emit(RideOrRequestFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  void initUpdateDeliveryRequest(int? requestId, int? orderId, String status,
      [bool isCustomOrder = false]) async {
    emit(const UpdateDeliveryRequestLoading());
    try {
      ProfileMode profileMode = (await LocalDataLayer().getProfileMode())!;
      if (status == "rejected") {
        try {
          await fire_db.FirebaseDatabase.instance
              .ref()
              .child("deliveries/${profileMode.delivery_profile_id}")
              .remove();
        } catch (e) {
          if (kDebugMode) {
            print("initUpdateDeliveryRequestFire: $e");
          }
        }
      }
      await _repository.updateDeliveryRequest(
          profileMode.delivery_profile_id!, requestId!, status);
      if (isCustomOrder && status == "accepted") {
        await _repository.updateDeliveryOrder(orderId!, {"status": status});
      }
      emit(const UpdateDeliveryRequestLoaded());
    } catch (e) {
      if (kDebugMode) {
        print("initUpdateDeliveryRequest: $e");
      }
      emit(UpdateDeliveryRequestFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  void initFetchOrder(int orderId) async {
    emit(const OrderLoading());
    try {
      Order order = await _repository.getOrderById(orderId);
      order.setup();
      emit(OrderLoaded(order, false));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchOrder: $e");
      }
      emit(OrderFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  void initUpdateOrder(int orderId, String deliveryStatus) async {
    emit(const OrderLoading());
    try {
      Order order = await _repository
          .updateDeliveryOrder(orderId, {"delivery_status": deliveryStatus});
      if (order.status == 'complete') {
        ProfileMode profileMode = (await LocalDataLayer().getProfileMode())!;
        try {
          await fire_db.FirebaseDatabase.instance
              .ref()
              .child("deliveries/${profileMode.delivery_profile_id}")
              .remove();
        } catch (e) {
          if (kDebugMode) {
            print("initUpdateOrderFire: $e");
          }
        }
      }
      order.setup();
      emit(OrderLoaded(order, true));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchOrder: $e");
      }
      emit(OrderFail(_getErrorMessage(e), "something_wrong"));
    }
  }

  String _getErrorMessage(Object e) {
    try {
      DioException de = (e as DioException);
      return (de.response?.statusCode ?? -1) > 499
          ? "Something went wrong"
          : de.response!.data["message"];
    } catch (e) {
      if (kDebugMode) {
        print("getErrorMessage: $e");
      }
      return "Something went wrong";
    }
  }

  Future<
      StreamSubscription<
          fire_db
          .DatabaseEvent>> registerRideUpdates(int rideId) => LocalDataLayer()
      .getProfileMode()
      .then((ProfileMode? profileMode) => _rideStream ??= fire_db
          .FirebaseDatabase.instance
          .ref()
          .child(
              "fire_app/drivers/${profileMode!.driver_profile_id}/rides/$rideId")
          .onValue
          .listen((fire_db.DatabaseEvent event) =>
              _handleFireAddedEvent(event, true)));

  Future<void> unRegisterRideUpdates() async {
    await _rideStream?.cancel();
    _rideStream = null;
  }

  Future<StreamSubscription<fire_db.DatabaseEvent>>
      registerRideRequestUpdates() => LocalDataLayer().getProfileMode().then(
          (ProfileMode? profileMode) => _rideRequestStream ??= fire_db
              .FirebaseDatabase.instance
              .ref()
              .child("fire_app/drivers/${profileMode!.driver_profile_id}/rides")
              .onChildAdded
              .listen((fire_db.DatabaseEvent event) =>
                  _handleFireAddedEvent(event, false)));

  Future<
      StreamSubscription<
          fire_db
          .DatabaseEvent>> registerOrderRequestUpdates() => LocalDataLayer()
      .getProfileMode()
      .then((ProfileMode? profileMode) => _orderRequestStream ??= fire_db
          .FirebaseDatabase.instance
          .ref()
          .child("deliveries/${profileMode!.delivery_profile_id}/order-request")
          .onValue
          .listen(
              (fire_db.DatabaseEvent event) => _handleFireOrderEvent(event)));

  Future<void> unRegisterRideRequestUpdates() async {
    await _rideRequestStream?.cancel();
    _rideRequestStream = null;
  }

  Future<void> unRegisterOrderRequestUpdates() async {
    await _orderRequestStream?.cancel();
    _orderRequestStream = null;
  }

  void _handleFireAddedEvent(fire_db.DatabaseEvent event, bool isUpdate) {
    if (event.snapshot.value != null) {
      try {
        if (!isUpdate) {
          emit(const RideUpdateLoading());
        }
        Map resultMap = event.snapshot.value as Map;
        Ride newRide = Ride.fromJson(jsonDecode(jsonEncode(resultMap)));
        newRide.setup();
        if (kDebugMode) {
          print("isUpdate: $isUpdate");
          print("handleFireAddedEvent: ${newRide.status}");
        }
        if (isUpdate) {
          emit(RideUpdateLoaded(newRide, null));
        } else if (newRide.isRequest) {
          emit(RideOrRequestLoaded(newRide, true));
        }
      } catch (e) {
        if (kDebugMode) {
          print("handleFireAddedEvent: $e");
        }
      }
    } else {
      if (isUpdate && state is RideUpdateLoaded) {
        emit(RideUpdateLoaded((state as RideUpdateLoaded).ride, "cancelled"));
      }
    }
  }

  void _handleFireOrderEvent(fire_db.DatabaseEvent event) {
    if (event.snapshot.value != null) {
      Map requestMap = event.snapshot.value as Map;
      try {
        OrderDeliveryRequest deliveryRequest =
            OrderDeliveryRequest.fromJson(jsonDecode(jsonEncode(requestMap)));
        if (kDebugMode) {
          print("deliveryRequestFromMap: ${deliveryRequest.toString()}");
        }
        if (deliveryRequest.status == "pending") {
          emit(OrderOrRequestLoaded(null, deliveryRequest));
        }
      } catch (e) {
        if (kDebugMode) {
          print("requestMapCastError: $e");
        }
      }
    }
  }
}
