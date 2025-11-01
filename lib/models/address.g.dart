// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      (json['id'] as num).toInt(),
      json['title'] as String?,
      json['formatted_address'] as String,
      (json['longitude'] as num).toDouble(),
      (json['latitude'] as num).toDouble(),
      json['type'] as String?,
      json['address1'] as String?,
      json['address2'] as String?,
      json['country'] as String?,
      json['state'] as String?,
      json['city'] as String?,
      json['postcode'] as String?,
      json['meta'],
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'formatted_address': instance.formatted_address,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'type': instance.type,
      'address1': instance.address1,
      'address2': instance.address2,
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'postcode': instance.postcode,
      'meta': instance.meta,
    };
