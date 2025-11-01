// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Faq _$FaqFromJson(Map<String, dynamic> json) => Faq(
      (json['id'] as num).toInt(),
      json['title'] as String,
      json['short_description'] as String,
      json['description'] as String,
      json['meta'],
    );

Map<String, dynamic> _$FaqToJson(Faq instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'short_description': instance.short_description,
      'description': instance.description,
      'meta': instance.meta,
    };
