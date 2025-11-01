// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleType _$VehicleTypeFromJson(Map<String, dynamic> json) => VehicleType(
      (json['id'] as num).toInt(),
      json['title'] as String,
      (json['base_fare'] as num?)?.toDouble(),
      (json['distance_charges_per_unit'] as num?)?.toDouble(),
      (json['time_charges_per_minute'] as num?)?.toDouble(),
      (json['other_charges'] as num?)?.toDouble(),
      (json['seats'] as num).toInt(),
      json['meta'],
      json['mediaurls'],
      json['type'] as String,
    )
      ..imageUrl = json['imageUrl'] as String?
      ..estimated_fare_subtotal =
          (json['estimated_fare_subtotal'] as num?)?.toDouble();

Map<String, dynamic> _$VehicleTypeToJson(VehicleType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'base_fare': instance.base_fare,
      'distance_charges_per_unit': instance.distance_charges_per_unit,
      'time_charges_per_minute': instance.time_charges_per_minute,
      'other_charges': instance.other_charges,
      'seats': instance.seats,
      'meta': instance.meta,
      'type': instance.type,
      'mediaurls': instance.mediaurls,
      'imageUrl': instance.imageUrl,
      'estimated_fare_subtotal': instance.estimated_fare_subtotal,
    };
