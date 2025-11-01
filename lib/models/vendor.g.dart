// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vendor _$VendorFromJson(Map<String, dynamic> json) => Vendor(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['tagline'] as String?,
      json['details'] as String?,
      json['meta'],
      json['mediaurls'],
      (json['minimum_order'] as num).toInt(),
      (json['delivery_fee'] as num).toDouble(),
      json['area'] as String?,
      json['address'] as String?,
      (json['longitude'] as num).toDouble(),
      (json['latitude'] as num).toDouble(),
      (json['is_verified'] as num).toInt(),
      (json['user_id'] as num).toInt(),
      json['created_at'] as String,
      json['updated_at'] as String,
      (json['ratings'] as num?)?.toDouble(),
      (json['ratings_count'] as num?)?.toInt(),
      (json['favourite_count'] as num?)?.toInt(),
      json['is_favourite'] as bool?,
      (json['distance'] as num?)?.toDouble(),
      (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['product_categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VendorToJson(Vendor instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tagline': instance.tagline,
      'details': instance.details,
      'meta': instance.meta,
      'mediaurls': instance.mediaurls,
      'minimum_order': instance.minimum_order,
      'delivery_fee': instance.delivery_fee,
      'area': instance.area,
      'address': instance.address,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'is_verified': instance.is_verified,
      'user_id': instance.user_id,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'ratings': instance.ratings,
      'ratings_count': instance.ratings_count,
      'favourite_count': instance.favourite_count,
      'is_favourite': instance.is_favourite,
      'distance': instance.distance,
      'categories': instance.categories,
      'product_categories': instance.product_categories,
      'user': instance.user,
    };
