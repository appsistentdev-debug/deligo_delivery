// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      (json['id'] as num).toInt(),
      json['notes'] as String?,
      json['meta'],
      (json['subtotal'] as num?)?.toDouble(),
      (json['taxes'] as num?)?.toDouble(),
      (json['delivery_fee'] as num?)?.toDouble(),
      (json['total'] as num?)?.toDouble(),
      (json['discount'] as num?)?.toDouble(),
      json['type'] as String?,
      json['order_type'] as String?,
      json['customer_name'] as String?,
      json['customer_email'] as String?,
      json['customer_mobile'] as String?,
      json['scheduled_on'] as String?,
      json['status'] as String?,
      (json['vendor_id'] as num?)?.toInt(),
      (json['user_id'] as num?)?.toInt(),
      json['created_at'] as String?,
      json['updated_at'] as String?,
      (json['products'] as List<dynamic>?)
          ?.map((e) => OrderProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['vendor'] == null
          ? null
          : Vendor.fromJson(json['vendor'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
      json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      json['source_address'] == null
          ? null
          : Address.fromJson(json['source_address'] as Map<String, dynamic>),
      json['delivery'] == null
          ? null
          : OrderDelivery.fromJson(json['delivery'] as Map<String, dynamic>),
      json['payment'] == null
          ? null
          : Payment.fromJson(json['payment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'notes': instance.notes,
      'meta': instance.meta,
      'subtotal': instance.subtotal,
      'taxes': instance.taxes,
      'delivery_fee': instance.delivery_fee,
      'total': instance.total,
      'discount': instance.discount,
      'type': instance.type,
      'order_type': instance.order_type,
      'customer_name': instance.customer_name,
      'customer_email': instance.customer_email,
      'customer_mobile': instance.customer_mobile,
      'scheduled_on': instance.scheduled_on,
      'status': instance.status,
      'vendor_id': instance.vendor_id,
      'user_id': instance.user_id,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'products': instance.products,
      'vendor': instance.vendor,
      'user': instance.user,
      'address': instance.address,
      'source_address': instance.source_address,
      'delivery': instance.delivery,
      'payment': instance.payment,
    };
