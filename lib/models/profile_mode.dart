// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class ProfileMode {
  String? riding_mode; //["delivery", "riding"]
  int? delivery_profile_id;
  int? driver_profile_id;

  ProfileMode(
      {this.riding_mode, this.delivery_profile_id, this.driver_profile_id});

  Map<String, dynamic> toMap() => {
        'riding_mode': riding_mode,
        'delivery_profile_id': delivery_profile_id,
        'driver_profile_id': driver_profile_id,
      };

  factory ProfileMode.fromMap(Map<String, dynamic> map) => ProfileMode(
        riding_mode: map['riding_mode'],
        delivery_profile_id: map['delivery_profile_id']?.toInt(),
        driver_profile_id: map['driver_profile_id']?.toInt(),
      );

  ProfileMode copyWith({
    String? riding_mode,
    int? delivery_profile_id,
    int? driver_profile_id,
  }) =>
      ProfileMode(
        riding_mode: riding_mode ?? this.riding_mode,
        delivery_profile_id: delivery_profile_id ?? this.delivery_profile_id,
        driver_profile_id: driver_profile_id ?? this.driver_profile_id,
      );

  String toJson() => json.encode(toMap());

  factory ProfileMode.fromJson(String source) =>
      ProfileMode.fromMap(json.decode(source));

  @override
  String toString() =>
      'ProfileMode(riding_mode: $riding_mode, delivery_profile_id: $delivery_profile_id, driver_profile_id: $driver_profile_id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileMode &&
        other.riding_mode == riding_mode &&
        other.delivery_profile_id == delivery_profile_id &&
        other.driver_profile_id == driver_profile_id;
  }

  @override
  int get hashCode =>
      riding_mode.hashCode ^
      delivery_profile_id.hashCode ^
      driver_profile_id.hashCode;
}
