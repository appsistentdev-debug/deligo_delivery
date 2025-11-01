// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductGroup _$ProductGroupFromJson(Map<String, dynamic> json) => ProductGroup(
      (json['id'] as num).toInt(),
      json['title'] as String,
      (json['max_choices'] as num).toInt(),
      (json['min_choices'] as num).toInt(),
      (json['product_id'] as num).toInt(),
      (json['addon_choices'] as List<dynamic>)
          .map((e) => ProductGroupChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductGroupToJson(ProductGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'max_choices': instance.max_choices,
      'min_choices': instance.min_choices,
      'product_id': instance.product_id,
      'addon_choices': instance.addon_choices,
    };
