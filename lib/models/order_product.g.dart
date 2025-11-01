// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProduct _$OrderProductFromJson(Map<String, dynamic> json) => OrderProduct(
      (json['id'] as num).toInt(),
      (json['quantity'] as num).toInt(),
      (json['total'] as num).toDouble(),
      (json['subtotal'] as num?)?.toDouble(),
      (json['order_id'] as num).toInt(),
      (json['vendor_product_id'] as num?)?.toInt(),
      VendorProduct.fromJson(json['vendor_product'] as Map<String, dynamic>),
      (json['addon_choices'] as List<dynamic>?)
          ?.map((e) => OrderGroupChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderProductToJson(OrderProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'total': instance.total,
      'subtotal': instance.subtotal,
      'order_id': instance.order_id,
      'vendor_product_id': instance.vendor_product_id,
      'vendor_product': instance.vendor_product,
      'addon_choices': instance.addon_choices,
    };
