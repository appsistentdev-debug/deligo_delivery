part of 'location_cubit.dart';

//MOTHER STATE
abstract class LocationState {
  const LocationState();
}

//COMMON BASE STATES
class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoaded extends LocationState {
  final double? lattitude;
  final double? longitude;

  LocationLoaded(this.lattitude, this.longitude);

  @override
  String toString() =>
      'LocationLoaded(lattitude: $lattitude, longitude: $longitude)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationLoaded &&
        other.lattitude == lattitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => lattitude.hashCode ^ longitude.hashCode;
}

class LocationFail extends LocationState {
  final String msgKey;
  const LocationFail(this.msgKey);

  @override
  String toString() => 'LocationFail(msgKey: $msgKey)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationFail && other.msgKey == msgKey;
  }

  @override
  int get hashCode => msgKey.hashCode;
}

class LocationPermissionStatus extends LocationState {
  final LocationPermission permissionGranted;
  LocationPermissionStatus(this.permissionGranted);

  bool isPermissionGranted() {
    return permissionGranted == LocationPermission.always || permissionGranted == LocationPermission.whileInUse;
  }

  @override
  String toString() =>
      'LocationPermissionStatus(permissionGranted: $permissionGranted)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationPermissionStatus &&
        other.permissionGranted == permissionGranted;
  }

  @override
  int get hashCode => permissionGranted.hashCode;
}
