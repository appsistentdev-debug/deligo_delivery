part of 'fetcher_cubit.dart';

/// ORDERS STATES START
class InsightLoading extends FetcherLoading {
  const InsightLoading();
}

class InsightLoaded extends FetcherLoaded {
  final Rating rating;
  const InsightLoaded(this.rating);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightLoaded &&
          runtimeType == other.runtimeType &&
          rating == other.rating;

  @override
  int get hashCode => rating.hashCode;
}

class InsightFailed extends FetcherFail {
  const InsightFailed(super.message, super.messageKey);
}

/// ORDERS STATES END

/// EARNINGINSIGHT STATES START
class LoadingEarningInsightState extends FetcherLoading {
  final String duration;
  const LoadingEarningInsightState(this.duration);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingEarningInsightState &&
          runtimeType == other.runtimeType &&
          duration == other.duration;

  @override
  int get hashCode => duration.hashCode;
}

class LoadedEarningInsightState extends FetcherLoaded {
  final EarningInsight earningInsight;
  const LoadedEarningInsightState(this.earningInsight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadedEarningInsightState &&
          runtimeType == other.runtimeType &&
          earningInsight == other.earningInsight;

  @override
  int get hashCode => earningInsight.hashCode;
}

/// EARNINGINSIGHT STATES END

/// ORDERS STATES START
class OrderLoading extends FetcherLoading {
  const OrderLoading();
}

class OrderLoaded extends FetcherLoaded {
  final Order order;
  final bool isUpdate;
  const OrderLoaded(this.order, this.isUpdate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderLoaded &&
          runtimeType == other.runtimeType &&
          order == other.order &&
          isUpdate == other.isUpdate;

  @override
  int get hashCode => order.hashCode ^ isUpdate.hashCode;
}

class OrderFail extends FetcherFail {
  OrderFail(super.message, super.messageKey);
}

/// ORDERS STATES END

/// UPDATINGDELIVERYREQUEST STATES START
class UpdateDeliveryRequestLoading extends FetcherLoading {
  const UpdateDeliveryRequestLoading();
}

class UpdateDeliveryRequestLoaded extends FetcherLoaded {
  const UpdateDeliveryRequestLoaded();
}

class UpdateDeliveryRequestFail extends FetcherFail {
  UpdateDeliveryRequestFail(super.message, super.messageKey);
}

/// UPDATINGDELIVERYREQUEST STATES END

/// SENDTOBANK STATES START
class SendtoBankLoading extends FetcherLoading {
  const SendtoBankLoading();
}

class SendtoBankLoaded extends FetcherLoaded {
  const SendtoBankLoaded();
}

class SendtoBankFail extends FetcherFail {
  SendtoBankFail(super.message, super.messageKey);
}

/// SENDTOBANK STATES END

/// RIDEUPDATE STATES START
class RideUpdateLoading extends FetcherLoading {
  const RideUpdateLoading();
}

class RideUpdateLoaded extends FetcherLoaded {
  final Ride ride;
  final String? requestStatus;
  const RideUpdateLoaded(this.ride, this.requestStatus);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideUpdateLoaded &&
          runtimeType == other.runtimeType &&
          ride == other.ride &&
          requestStatus == other.requestStatus;

  @override
  int get hashCode => ride.hashCode ^ requestStatus.hashCode;
}

class RideUpdateFail extends FetcherFail {
  RideUpdateFail(super.message, super.messageKey);
}

/// RIDEUPDATE STATES END

/// RIDEORREQUEST STATES START
class RideOrRequestLoading extends FetcherLoading {
  const RideOrRequestLoading();
}

class RideOrRequestLoaded extends FetcherLoaded {
  final Ride ride;
  final bool isRequest;
  const RideOrRequestLoaded(this.ride, this.isRequest);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideOrRequestLoaded &&
          runtimeType == other.runtimeType &&
          ride == other.ride &&
          isRequest == other.isRequest;

  @override
  int get hashCode => ride.hashCode ^ isRequest.hashCode;
}

class OrderOrRequestLoaded extends FetcherLoaded {
  final Order? order;
  final OrderDeliveryRequest? orderDeliveryRequest;
  const OrderOrRequestLoaded(this.order, this.orderDeliveryRequest);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderOrRequestLoaded &&
          runtimeType == other.runtimeType &&
          order == other.order &&
          orderDeliveryRequest == other.orderDeliveryRequest;

  @override
  int get hashCode => order.hashCode ^ orderDeliveryRequest.hashCode;
}

class RideOrRequestFail extends FetcherFail {
  RideOrRequestFail(super.message, super.messageKey);
}

/// RIDEORREQUEST STATES END

/// RIDES STATES START
class RidesLoading extends FetcherLoading {
  const RidesLoading();
}

class RidesLoaded extends FetcherLoaded {
  final BaseListResponse<Ride> rides;
  const RidesLoaded(this.rides);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RidesLoaded &&
          runtimeType == other.runtimeType &&
          rides == other.rides;

  @override
  int get hashCode => rides.hashCode;
}

class RidesFail extends FetcherFail {
  RidesFail(super.message, super.messageKey);
}

/// RIDES STATES END

/// RIDEINSIGHT STATES START
class RideSummaryLoading extends FetcherLoading {
  const RideSummaryLoading();
}

class RideSummaryLoaded extends FetcherLoaded {
  final RideSummary rideSummary;
  const RideSummaryLoaded(this.rideSummary);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideSummaryLoaded &&
          runtimeType == other.runtimeType &&
          rideSummary == other.rideSummary;

  @override
  int get hashCode => rideSummary.hashCode;
}

class RideSummaryFail extends FetcherFail {
  RideSummaryFail(super.message, super.messageKey);
}

/// RIDEINSIGHT STATES END

/// WALLETTRANSACTIONS STATES START
class WalletTransactionsLoading extends FetcherLoading {
  const WalletTransactionsLoading();
}

class WalletTransactionsLoaded extends FetcherLoaded {
  final BaseListResponse<Transaction> transactions;
  const WalletTransactionsLoaded(this.transactions);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletTransactionsLoaded &&
          runtimeType == other.runtimeType &&
          transactions == other.transactions;

  @override
  int get hashCode => transactions.hashCode;
}

class WalletTransactionsFail extends FetcherFail {
  WalletTransactionsFail(super.message, super.messageKey);
}

/// WALLETTRANSACTIONS STATES END

/// WALLETBALANCE STATES START
class WalletBalanceLoading extends FetcherLoading {
  const WalletBalanceLoading();
}

class WalletBalanceLoaded extends FetcherLoaded {
  final Wallet wallet;
  const WalletBalanceLoaded(this.wallet);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletBalanceLoaded &&
          runtimeType == other.runtimeType &&
          wallet == other.wallet;

  @override
  int get hashCode => wallet.hashCode;
}

class WalletBalanceFail extends FetcherFail {
  WalletBalanceFail(super.message, super.messageKey);
}

/// WALLETBALANCE STATES END

/// REVIEWS STATES START
class ReviewsLoading extends FetcherLoading {
  const ReviewsLoading();
}

class ReviewsLoaded extends FetcherLoaded {
  final BaseListResponse<Review> reviews;
  const ReviewsLoaded(this.reviews);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewsLoaded &&
          runtimeType == other.runtimeType &&
          reviews == other.reviews;

  @override
  int get hashCode => reviews.hashCode;
}

class ReviewsFail extends FetcherFail {
  ReviewsFail(super.message, super.messageKey);
}

/// REVIEWS STATES END

/// RATINGS STATES START
class RatingLoading extends FetcherLoading {
  const RatingLoading();
}

class RatingLoaded extends FetcherLoaded {
  final Rating rating;
  const RatingLoaded(this.rating);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingLoaded &&
          runtimeType == other.runtimeType &&
          rating == other.rating;

  @override
  int get hashCode => rating.hashCode;
}

class RatingFail extends FetcherFail {
  RatingFail(super.message, super.messageKey);
}

/// RATINGS STATES END

/// VEHICLETYPES STATES START
class VehicleTypeLoading extends FetcherLoading {
  const VehicleTypeLoading();
}

class VehicleTypeLoaded extends FetcherLoaded {
  final List<VehicleType> vehicleTypes;
  const VehicleTypeLoaded(this.vehicleTypes);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleTypeLoaded &&
          runtimeType == other.runtimeType &&
          vehicleTypes == other.vehicleTypes;

  @override
  int get hashCode => vehicleTypes.hashCode;
}

class VehicleTypeFail extends FetcherFail {
  VehicleTypeFail(super.message, super.messageKey);
}

/// VEHICLETYPES STATES END

/// DRIVERPROFILEUPDATE STATES START
class ProfileMeUpdateLoading extends FetcherLoading {
  const ProfileMeUpdateLoading();
}

class ProfileMeUpdateLoaded extends FetcherLoaded {
  final DriverProfile driverProfile;
  const ProfileMeUpdateLoaded(this.driverProfile);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileMeUpdateLoaded &&
          runtimeType == other.runtimeType &&
          driverProfile == other.driverProfile;

  @override
  int get hashCode => driverProfile.hashCode;
}

class ProfileMeUpdateFail extends FetcherFail {
  ProfileMeUpdateFail(super.message, super.messageKey);
}

/// DRIVERPROFILEUPDATE STATES END

/// DRIVERPROFILE STATES START
class ProfileMeLoading extends FetcherLoading {
  const ProfileMeLoading();
}

class ProfileMeLoaded extends FetcherLoaded {
  final DriverProfile driverProfile;
  final String? ridingMode;
  const ProfileMeLoaded(this.driverProfile, this.ridingMode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileMeLoaded &&
          runtimeType == other.runtimeType &&
          driverProfile == other.driverProfile &&
          ridingMode == other.ridingMode;

  @override
  int get hashCode => driverProfile.hashCode ^ ridingMode.hashCode;
}

class ProfileMeFail extends FetcherFail {
  ProfileMeFail(super.message, super.messageKey);
}

/// DRIVERPROFILE STATES END

/// USERNOTIFICATIONS STATES START
class UserNotificationsLoading extends FetcherLoading {
  const UserNotificationsLoading();
}

class UserNotificationsLoaded extends FetcherLoaded {
  final BaseListResponse<UserNotification> notifications;
  const UserNotificationsLoaded(this.notifications);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserNotificationsLoaded &&
        other.notifications == notifications;
  }

  @override
  int get hashCode => notifications.hashCode;
}

class UserNotificationsFail extends FetcherFail {
  UserNotificationsFail(super.message, super.messageKey);
}

/// USERNOTIFICATIONS STATES END

/// BANNERS STATES START
class BannersLoading extends FetcherLoading {
  const BannersLoading();
}

class BannersLoaded extends FetcherLoaded {
  final List<my_category.Category> banners;
  const BannersLoaded(this.banners);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BannersLoaded &&
        foundation.listEquals(other.banners, banners);
  }

  @override
  int get hashCode => banners.hashCode;
}

class BannersFail extends FetcherFail {
  BannersFail(super.message, super.messageKey);
}

/// BANNERS STATES END

/// CATEGORIES STATES START
class CategoriesLoading extends FetcherLoading {
  const CategoriesLoading();
}

class CategoriesLoaded extends FetcherLoaded {
  final List<my_category.Category> categories;
  const CategoriesLoaded(this.categories);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoriesLoaded &&
        foundation.listEquals(other.categories, categories);
  }

  @override
  int get hashCode => categories.hashCode;
}

class CategoriesFail extends FetcherFail {
  CategoriesFail(super.message, super.messageKey);
}

/// CATEGORIES STATES END

/// ADDRESSDELETE STATES START
class AddressDeleteLoading extends FetcherLoading {
  const AddressDeleteLoading();
}

class AddressDeleteLoaded extends FetcherLoaded {
  final int addressId;
  const AddressDeleteLoaded(this.addressId);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressDeleteLoaded && other.addressId == addressId;
  }

  @override
  int get hashCode => addressId.hashCode;
}

class AddressDeleteFail extends FetcherFail {
  AddressDeleteFail(super.message, super.messageKey);
}

/// ADDRESSDELETE STATES END

/// ADDRESSUPDATE STATES START
class AddressUpdateLoading extends FetcherLoading {
  const AddressUpdateLoading();
}

class AddressUpdateLoaded extends FetcherLoaded {
  final Address address;
  const AddressUpdateLoaded(this.address);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressUpdateLoaded && other.address == address;
  }

  @override
  int get hashCode => address.hashCode;
}

class AddressUpdateFail extends FetcherFail {
  AddressUpdateFail(super.message, super.messageKey);
}

/// ADDRESSUPDATE STATES END

/// ADDRESSADD STATES START
class AddressAddLoading extends FetcherLoading {
  const AddressAddLoading();
}

class AddressAddLoaded extends FetcherLoaded {
  final Address address;
  const AddressAddLoaded(this.address);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressAddLoaded && other.address == address;
  }

  @override
  int get hashCode => address.hashCode;
}

class AddressAddFail extends FetcherFail {
  AddressAddFail(super.message, super.messageKey);
}

/// ADDRESSADD STATES END

/// GEOCODING STATES START
class GeocodeLoading extends FetcherLoading {
  const GeocodeLoading();
}

class GeocodeLoaded extends FetcherLoaded {
  final String address;
  final LatLng latLng;
  const GeocodeLoaded(this.address, this.latLng);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeocodeLoaded &&
        other.address == address &&
        other.latLng == latLng;
  }

  @override
  int get hashCode => address.hashCode ^ latLng.hashCode;
}

class GeocodeFail extends FetcherFail {
  GeocodeFail(super.message, super.messageKey);
}

/// GEOCODING STATES END

/// REVERSEGEOCODING STATES START
class ReverseGeocodeLoading extends FetcherLoading {
  const ReverseGeocodeLoading();
}

class ReverseGeocodeLoaded extends FetcherLoaded {
  final String address;
  final LatLng latLng;
  const ReverseGeocodeLoaded(this.address, this.latLng);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReverseGeocodeLoaded &&
        other.address == address &&
        other.latLng == latLng;
  }

  @override
  int get hashCode => address.hashCode ^ latLng.hashCode;
}

class ReverseGeocodeFail extends FetcherFail {
  ReverseGeocodeFail(super.message, super.messageKey);
}

/// REVERSEGEOCODING STATES END

/// ADDRESS STATES START
class AddressesLoading extends FetcherLoading {
  const AddressesLoading();
}

class AddressesLoaded extends FetcherLoaded {
  final List<Address> addresses;
  const AddressesLoaded(this.addresses);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressesLoaded &&
        foundation.listEquals(other.addresses, addresses);
  }

  @override
  int get hashCode => addresses.hashCode;
}

class AddressesLoadFail extends FetcherFail {
  AddressesLoadFail(super.message, super.messageKey);
}

/// ADDRESS STATES END

/// FAQ STATES START
class FaqLoading extends FetcherLoading {
  const FaqLoading();
}

class FaqLoaded extends FetcherLoaded {
  final List<Faq> faqs;
  const FaqLoaded(this.faqs);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FaqLoaded && foundation.listEquals(other.faqs, faqs);
  }

  @override
  int get hashCode => faqs.hashCode;
}

class FaqLoadFail extends FetcherFail {
  FaqLoadFail(super.message, super.messageKey);
}

/// FAQ STATES END

/// SUPPORT STATES START
class SupportLoading extends FetcherLoading {
  const SupportLoading();
}

class SupportLoaded extends FetcherLoaded {
  const SupportLoaded();
}

class SupportLoadFail extends FetcherFail {
  SupportLoadFail(super.message, super.messageKey);
}

/// SUPPORT STATES END

/// USERME STATES START
class UserMeLoading extends FetcherLoading {
  const UserMeLoading();
}

class UserMeUpdating extends FetcherLoading {
  const UserMeUpdating();
}

class UserMeLoaded extends FetcherLoaded {
  final UserData userMe;

  UserMeLoaded(this.userMe) {
    userMe.setup();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserMeLoaded &&
          runtimeType == other.runtimeType &&
          userMe == other.userMe;

  @override
  int get hashCode => userMe.hashCode;
}

class UserMeError extends FetcherFail {
  UserMeError(super.message, super.messageKey);
}

/// USERME STATES END

/// BASE STATES START
abstract class FetcherState {
  const FetcherState();
}

class FetcherInitial extends FetcherState {
  const FetcherInitial();
}

class FetcherLoading extends FetcherState {
  const FetcherLoading();
}

class FetcherLoaded extends FetcherState {
  const FetcherLoaded();
}

class FetcherFail extends FetcherState {
  final String message, messageKey;

  const FetcherFail(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FetcherFail &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;
}
/// BASE STATES END