// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_group_choice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductGroupChoice _$ProductGroupChoiceFromJson(Map<String, dynamic> json) =>
    ProductGroupChoice(
      (json['id'] as num).toInt(),
      json['title'] as String,
      (json['price'] as num).toDouble(),
      (json['product_addon_group_id'] as num).toInt(),
      json['created_at'] as String,
      json['updated_at'] as String,
    );

Map<String, dynamic> _$ProductGroupChoiceToJson(ProductGroupChoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'product_addon_group_id': instance.product_addon_group_id,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
