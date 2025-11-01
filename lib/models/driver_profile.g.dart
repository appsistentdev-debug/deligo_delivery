// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverProfile _$DriverProfileFromJson(Map<String, dynamic> json) =>
    DriverProfile(
      (json['id'] as num).toInt(),
      (json['is_verified'] as num).toInt(),
      (json['is_online'] as num).toInt(),
      (json['ratings_count'] as num?)?.toInt(),
      (json['current_latitude'] as num?)?.toDouble(),
      (json['current_longitude'] as num?)?.toDouble(),
      (json['distance_remaining'] as num?)?.toDouble(),
      (json['ratings'] as num?)?.toDouble(),
      (json['vehicletypes'] as List<dynamic>?)
          ?.map((e) => VehicleType.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
      json['meta'],
    );

Map<String, dynamic> _$DriverProfileToJson(DriverProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_verified': instance.is_verified,
      'is_online': instance.is_online,
      'ratings_count': instance.ratings_count,
      'current_latitude': instance.current_latitude,
      'current_longitude': instance.current_longitude,
      'distance_remaining': instance.distance_remaining,
      'ratings': instance.ratings,
      'vehicletypes': instance.vehicletypes,
      'user': instance.user,
      'meta': instance.meta,
    };
