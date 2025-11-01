// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_profile_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverProfileUpdateRequest _$DriverProfileUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    DriverProfileUpdateRequest(
      vehicletypes: (json['vehicletypes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      is_online: (json['is_online'] as num?)?.toInt(),
      current_latitude: (json['current_latitude'] as num?)?.toDouble(),
      current_longitude: (json['current_longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      meta: json['meta'] as String?,
    );

Map<String, dynamic> _$DriverProfileUpdateRequestToJson(
        DriverProfileUpdateRequest instance) =>
    <String, dynamic>{
      'vehicletypes': instance.vehicletypes,
      'is_online': instance.is_online,
      'current_latitude': instance.current_latitude,
      'current_longitude': instance.current_longitude,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'meta': instance.meta,
    };
