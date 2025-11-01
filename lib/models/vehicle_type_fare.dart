// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'vehicle_type_fare.g.dart';

@JsonSerializable()
class VehicleTypeFare {
  final int vehicle_type_id;
  final double? estimated_fare_subtotal;

  VehicleTypeFare(this.vehicle_type_id, this.estimated_fare_subtotal);

  factory VehicleTypeFare.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeFareFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleTypeFareToJson(this);
}
