// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_group_choice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderGroupChoice _$OrderGroupChoiceFromJson(Map<String, dynamic> json) =>
    OrderGroupChoice(
      (json['id'] as num).toInt(),
      ProductGroupChoice.fromJson(json['addon_choice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderGroupChoiceToJson(OrderGroupChoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'addon_choice': instance.addon_choice,
    };
