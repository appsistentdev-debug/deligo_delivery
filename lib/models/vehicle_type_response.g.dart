// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_type_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleTypeResponse _$VehicleTypeResponseFromJson(Map<String, dynamic> json) =>
    VehicleTypeResponse(
      (json['vehicle_types'] as List<dynamic>)
          .map((e) => VehicleType.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['fares'] as List<dynamic>)
          .map((e) => VehicleTypeFare.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VehicleTypeResponseToJson(
        VehicleTypeResponse instance) =>
    <String, dynamic>{
      'vehicle_types': instance.vehicle_types,
      'fares': instance.fares,
    };
