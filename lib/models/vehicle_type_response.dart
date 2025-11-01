// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'vehicle_type.dart';
import 'vehicle_type_fare.dart';

part 'vehicle_type_response.g.dart';

@JsonSerializable()
class VehicleTypeResponse {
  final List<VehicleType> vehicle_types;
  final List<VehicleTypeFare> fares;

  VehicleTypeResponse(this.vehicle_types, this.fares);

  factory VehicleTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleTypeResponseToJson(this);
}
