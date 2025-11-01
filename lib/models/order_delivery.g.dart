// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDelivery _$OrderDeliveryFromJson(Map<String, dynamic> json) =>
    OrderDelivery(
      (json['id'] as num).toInt(),
      json['status'] as String,
      (json['order_id'] as num?)?.toInt(),
      DriverProfile.fromJson(json['delivery'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderDeliveryToJson(OrderDelivery instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'order_id': instance.order_id,
      'delivery': instance.delivery,
    };
