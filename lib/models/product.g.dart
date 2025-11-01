// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      (json['id'] as num).toInt(),
      json['title'] as String,
      json['detail'] as String,
      json['meta'],
      (json['price'] as num).toDouble(),
      json['owner'] as String,
      (json['parent_id'] as num?)?.toInt(),
      (json['attribute_term_id'] as num?)?.toInt(),
      json['mediaurls'],
      json['created_at'] as String,
      json['updated_at'] as String,
      (json['addon_groups'] as List<dynamic>?)
          ?.map((e) => ProductGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['vendor_products'] as List<dynamic>?)
          ?.map((e) => VendorProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['ratings'] as num?)?.toDouble(),
      (json['ratings_count'] as num?)?.toInt(),
      (json['favourite_count'] as num?)?.toInt(),
      json['is_favourite'] as bool?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'detail': instance.detail,
      'meta': instance.meta,
      'price': instance.price,
      'owner': instance.owner,
      'parent_id': instance.parent_id,
      'attribute_term_id': instance.attribute_term_id,
      'mediaurls': instance.mediaurls,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'addon_groups': instance.addon_groups,
      'categories': instance.categories,
      'vendor_products': instance.vendor_products,
      'ratings': instance.ratings,
      'ratings_count': instance.ratings_count,
      'favourite_count': instance.favourite_count,
      'is_favourite': instance.is_favourite,
    };
