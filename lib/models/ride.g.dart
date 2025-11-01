// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ride _$RideFromJson(Map<String, dynamic> json) => Ride(
      (json['id'] as num).toInt(),
      json['address_from'] as String,
      json['latitude_from'] as String,
      json['longitude_from'] as String,
      json['address_to'] as String,
      json['latitude_to'] as String,
      json['longitude_to'] as String,
      json['ride_start_at'] as String?,
      json['ride_ends_at'] as String?,
      json['ride_on'] as String,
      (json['is_scheduled'] as num?)?.toInt(),
      (json['estimated_pickup_distance'] as num?)?.toDouble(),
      (json['estimated_pickup_time'] as num?)?.toDouble(),
      (json['estimated_distance'] as num?)?.toDouble(),
      (json['final_distance'] as num?)?.toDouble(),
      (json['estimated_time'] as num?)?.toDouble(),
      (json['final_time'] as num?)?.toDouble(),
      (json['estimated_fare_subtotal'] as num?)?.toDouble(),
      (json['estimated_fare_total'] as num?)?.toDouble(),
      (json['final_fare_total'] as num?)?.toDouble(),
      (json['final_fare_subtotal'] as num?)?.toDouble(),
      json['cancelled_by'] as String?,
      json['cancel_reason'] as String?,
      json['status'] as String,
      json['type'] as String?,
      json['vehicle_type'] == null
          ? null
          : VehicleType.fromJson(json['vehicle_type'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
      json['driver'] == null
          ? null
          : DriverProfile.fromJson(json['driver'] as Map<String, dynamic>),
      json['payment'] == null
          ? null
          : Payment.fromJson(json['payment'] as Map<String, dynamic>),
      json['meta'],
    );

Map<String, dynamic> _$RideToJson(Ride instance) => <String, dynamic>{
      'id': instance.id,
      'address_from': instance.address_from,
      'latitude_from': instance.latitude_from,
      'longitude_from': instance.longitude_from,
      'address_to': instance.address_to,
      'latitude_to': instance.latitude_to,
      'longitude_to': instance.longitude_to,
      'ride_start_at': instance.ride_start_at,
      'ride_ends_at': instance.ride_ends_at,
      'ride_on': instance.ride_on,
      'is_scheduled': instance.is_scheduled,
      'estimated_pickup_distance': instance.estimated_pickup_distance,
      'estimated_pickup_time': instance.estimated_pickup_time,
      'estimated_distance': instance.estimated_distance,
      'final_distance': instance.final_distance,
      'estimated_time': instance.estimated_time,
      'final_time': instance.final_time,
      'estimated_fare_subtotal': instance.estimated_fare_subtotal,
      'estimated_fare_total': instance.estimated_fare_total,
      'final_fare_total': instance.final_fare_total,
      'final_fare_subtotal': instance.final_fare_subtotal,
      'cancelled_by': instance.cancelled_by,
      'cancel_reason': instance.cancel_reason,
      'status': instance.status,
      'type': instance.type,
      'vehicle_type': instance.vehicle_type,
      'user': instance.user,
      'driver': instance.driver,
      'payment': instance.payment,
      'meta': instance.meta,
    };
