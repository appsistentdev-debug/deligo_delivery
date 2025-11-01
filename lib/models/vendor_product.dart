// ignore_for_file: non_constant_identifier_names

import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

import 'product.dart';
import 'vendor.dart';

part 'vendor_product.g.dart';

@JsonSerializable()
class VendorProduct {
  final int id;
  final double price;
  final double? sale_price;
  final double? sale_price_from;
  final double? sale_price_to;
  final int? stock_quantity;
  final int stock_low_threshold;
  final int product_id;
  final int vendor_id;
  final Vendor? vendor;
  final Product? product;
  final int? sells_count;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? priceFormatted;

  VendorProduct(
      this.id,
      this.price,
      this.sale_price,
      this.sale_price_from,
      this.sale_price_to,
      this.stock_quantity,
      this.stock_low_threshold,
      this.product_id,
      this.vendor_id,
      this.vendor,
      this.product,
      this.sells_count);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VendorProduct && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory VendorProduct.fromJson(Map<String, dynamic> json) =>
      _$VendorProductFromJson(json);

  Map<String, dynamic> toJson() => _$VendorProductToJson(this);

  void setup() {
    priceFormatted =
        "${AppSettings.currencyIcon} ${Helper.formatNumber(num.tryParse("$price") ?? 0)}";
    vendor?.setup();
  }
}
