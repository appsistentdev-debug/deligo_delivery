// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:deligo_delivery/models/vehicle_type.dart';
import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/utility/string_extensions.dart';

import 'driver_profile.dart';
import 'payment.dart';
import 'user_data.dart';

part 'ride.g.dart';

@JsonSerializable()
class Ride {
  final int id;
  final String address_from;
  final String latitude_from;
  final String longitude_from;
  final String address_to;
  final String latitude_to;
  final String longitude_to;
  final String? ride_start_at;
  final String? ride_ends_at;
  final String ride_on;
  final int? is_scheduled;

  final double? estimated_pickup_distance;
  final double? estimated_pickup_time;
  final double? estimated_distance;
  final double? final_distance;
  final double? estimated_time;
  final double? final_time;
  final double? estimated_fare_subtotal;
  final double? estimated_fare_total;
  final double? final_fare_total;
  final double? final_fare_subtotal;

  final String? cancelled_by;
  final String? cancel_reason;
  final String
      status; //["pending", "accepted", "onway", "ongoing", "complete", "cancelled", "rejected"]
  final String? type; //["ride", "intercity", "courier"]

  final VehicleType? vehicle_type;
  final UserData? user;
  final DriverProfile? driver;
  final Payment? payment;

  final dynamic meta;

  bool get isOngoing =>
      ["accepted", "onway", "ongoing"].contains(status.toLowerCase());

  bool get isRequest => ["pending"].contains(status.toLowerCase());

  bool get isPast =>
      ["cancelled", "rejected", "complete"].contains(status.toLowerCase());

  static bool isRidePast(String? requestStatus) =>
      ["cancelled", "rejected", "complete"].contains(requestStatus);

  String? getMetaValue(String metaKey) {
    try {
      if (meta is Map) {
        return (meta as Map)[metaKey];
      }
    } catch (e) {
      if (kDebugMode) {
        print("getMetaValue: $e");
      }
    }
    return null;
  }

  String get fare_formatted =>
      "${AppSettings.currencyIcon} ${(final_fare_total ?? estimated_fare_total ?? 0).toStringAsFixed(2)}";

  String get final_distance_formatted =>
      "${(final_distance ?? 0.0).toStringAsFixed(2)} ${AppSettings.distanceMetric.capitalizeFirst()}";

  String get estimated_distance_formatted =>
      "${(estimated_distance ?? 0.0).toStringAsFixed(2)} ${AppSettings.distanceMetric.capitalizeFirst()}";

  Ride(
      this.id,
      this.address_from,
      this.latitude_from,
      this.longitude_from,
      this.address_to,
      this.latitude_to,
      this.longitude_to,
      this.ride_start_at,
      this.ride_ends_at,
      this.ride_on,
      this.is_scheduled,
      this.estimated_pickup_distance,
      this.estimated_pickup_time,
      this.estimated_distance,
      this.final_distance,
      this.estimated_time,
      this.final_time,
      this.estimated_fare_subtotal,
      this.estimated_fare_total,
      this.final_fare_total,
      this.final_fare_subtotal,
      this.cancelled_by,
      this.cancel_reason,
      this.status,
      this.type,
      this.vehicle_type,
      this.user,
      this.driver,
      this.payment,
      this.meta);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ride && other.id == id && other.status == status;
  }

  @override
  int get hashCode => id.hashCode ^ status.hashCode;

  Map<String, dynamic> toJson() => _$RideToJson(this);

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

  void setup() {
    user?.setup();
  }
}
