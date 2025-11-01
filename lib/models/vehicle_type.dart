// ignore_for_file: non_constant_identifier_names
import 'package:deligo_delivery/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_type.g.dart';

@JsonSerializable()
class VehicleType {
  final int id;
  final String title;
  final double? base_fare;
  final double? distance_charges_per_unit;
  final double? time_charges_per_minute;
  final double? other_charges;
  final int seats;
  final dynamic meta;
  final String type;
  dynamic mediaurls;
  String? imageUrl;
  double? estimated_fare_subtotal;

  VehicleType(
    this.id,
    this.title,
    this.base_fare,
    this.distance_charges_per_unit,
    this.time_charges_per_minute,
    this.other_charges,
    this.seats,
    this.meta,
    this.mediaurls,
    this.type,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VehicleType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'VehicleType{type: $type}';
  }

  factory VehicleType.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleTypeToJson(this);

  void setup() {
    imageUrl = Helper.getMediaUrl(mediaurls);
  }
}
