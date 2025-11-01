// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_type_fare.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleTypeFare _$VehicleTypeFareFromJson(Map<String, dynamic> json) =>
    VehicleTypeFare(
      (json['vehicle_type_id'] as num).toInt(),
      (json['estimated_fare_subtotal'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VehicleTypeFareToJson(VehicleTypeFare instance) =>
    <String, dynamic>{
      'vehicle_type_id': instance.vehicle_type_id,
      'estimated_fare_subtotal': instance.estimated_fare_subtotal,
    };
