// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user_data.dart';
import 'vehicle_type.dart';

part 'driver_profile.g.dart';

@JsonSerializable()
class DriverProfile {
  final int id;
  final int is_verified;
  final int is_online;
  final int? ratings_count;
  final double? current_latitude;
  final double? current_longitude;
  final double? distance_remaining;
  final double? ratings;
  final List<VehicleType>? vehicletypes;
  final UserData? user;
  final dynamic meta;

  static DriverProfile onlyUser(UserData user) => DriverProfile.fromJson({
        "id": -1,
        "is_verified": 0,
        "is_online": 0,
        "user": jsonDecode(jsonEncode(user.toJson())),
      });

  DriverProfile(
      this.id,
      this.is_verified,
      this.is_online,
      this.ratings_count,
      this.current_latitude,
      this.current_longitude,
      this.distance_remaining,
      this.ratings,
      this.vehicletypes,
      this.user,
      this.meta);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DriverProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory DriverProfile.fromJson(Map<String, dynamic> json) =>
      _$DriverProfileFromJson(json);

  String? metaValue(String key) {
    String? toReturn;
    try {
      toReturn = (meta as Map)[key];
    } catch (e) {
      if (kDebugMode) {
        print("metaValue[$key]: $e");
      }
    }
    return toReturn;
  }

  Map<String, dynamic> toJson() => _$DriverProfileToJson(this);

  void setup() {
    user?.setup();
  }
}
