// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      (json['id'] as num?)?.toInt(),
      (json['enabled'] as num?)?.toInt(),
      json['slug'] as String?,
      json['title'] as String?,
      json['type'] as String?,
      json['meta'],
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'enabled': instance.enabled,
      'slug': instance.slug,
      'title': instance.title,
      'type': instance.type,
      'meta': instance.dynamicMeta,
    };
