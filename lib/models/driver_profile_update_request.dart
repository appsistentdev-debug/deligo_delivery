// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'driver_profile_update_request.g.dart';

@JsonSerializable()
class DriverProfileUpdateRequest {
  List<int>? vehicletypes;
  int? is_online;
  double? current_latitude;
  double? current_longitude;
  double? latitude;
  double? longitude;
  String? meta;
  DriverProfileUpdateRequest({
    this.vehicletypes,
    this.is_online,
    this.current_latitude,
    this.current_longitude,
    this.latitude,
    this.longitude,
    this.meta,
  });

  factory DriverProfileUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$DriverProfileUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DriverProfileUpdateRequestToJson(this);
}
