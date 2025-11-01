// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorProduct _$VendorProductFromJson(Map<String, dynamic> json) =>
    VendorProduct(
      (json['id'] as num).toInt(),
      (json['price'] as num).toDouble(),
      (json['sale_price'] as num?)?.toDouble(),
      (json['sale_price_from'] as num?)?.toDouble(),
      (json['sale_price_to'] as num?)?.toDouble(),
      (json['stock_quantity'] as num?)?.toInt(),
      (json['stock_low_threshold'] as num).toInt(),
      (json['product_id'] as num).toInt(),
      (json['vendor_id'] as num).toInt(),
      json['vendor'] == null
          ? null
          : Vendor.fromJson(json['vendor'] as Map<String, dynamic>),
      json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      (json['sells_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VendorProductToJson(VendorProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'sale_price': instance.sale_price,
      'sale_price_from': instance.sale_price_from,
      'sale_price_to': instance.sale_price_to,
      'stock_quantity': instance.stock_quantity,
      'stock_low_threshold': instance.stock_low_threshold,
      'product_id': instance.product_id,
      'vendor_id': instance.vendor_id,
      'vendor': instance.vendor,
      'product': instance.product,
      'sells_count': instance.sells_count,
    };
