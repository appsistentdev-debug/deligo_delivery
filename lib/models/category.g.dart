// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      (json['id'] as num).toInt(),
      (json['parent_id'] as num?)?.toInt(),
      json['slug'] as String?,
      json['title'] as String,
      json['mediaurls'],
      json['meta'],
    )..image_url = json['image_url'] as String?;

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parent_id,
      'slug': instance.slug,
      'title': instance.title,
      'mediaurls': instance.mediaurls,
      'meta': instance.meta,
      'image_url': instance.image_url,
    };
