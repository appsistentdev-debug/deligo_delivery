// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_delivery_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDeliveryRequest _$OrderDeliveryRequestFromJson(
        Map<String, dynamic> json) =>
    OrderDeliveryRequest(
      (json['id'] as num?)?.toInt(),
      (json['delivery_profile_id'] as num?)?.toInt(),
      json['order'] == null
          ? null
          : Order.fromJson(json['order'] as Map<String, dynamic>),
      json['delivery'] == null
          ? null
          : DriverProfile.fromJson(json['delivery'] as Map<String, dynamic>),
      json['status'] as String?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
    );

Map<String, dynamic> _$OrderDeliveryRequestToJson(
        OrderDeliveryRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'delivery_profile_id': instance.delivery_profile_id,
      'order': instance.order,
      'delivery': instance.delivery,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
