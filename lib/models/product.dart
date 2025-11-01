// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

import 'category.dart';
import 'product_group.dart';
import 'product_group_choice.dart';
import 'vendor_product.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final String title;
  final String detail;
  final dynamic meta;
  final double price;
  final String owner;
  final int? parent_id;
  final int? attribute_term_id;
  final dynamic mediaurls;
  final String created_at;
  final String updated_at;
  final List<ProductGroup>? addon_groups;
  final List<Category>? categories;
  final List<VendorProduct>? vendor_products;
  final double? ratings;
  final int? ratings_count;
  final int? favourite_count;
  final bool? is_favourite;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String>? imageUrls;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? foodType; //"veg", "non_veg", null
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? stockQuantity; //-1=unlimited, 0=outOfStock
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? addOnChoicesIsMust;
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? sale_price;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? priceSaleFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? priceFormatted;
  // @JsonKey(includeFromJson: false, includeToJson: false)
  // int? quantity;

  Product(
      this.id,
      this.title,
      this.detail,
      this.meta,
      this.price,
      this.owner,
      this.parent_id,
      this.attribute_term_id,
      this.mediaurls,
      this.created_at,
      this.updated_at,
      this.addon_groups,
      this.categories,
      this.vendor_products,
      this.ratings,
      this.ratings_count,
      this.favourite_count,
      this.is_favourite);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  void setup() {
    imageUrls = Helper.getMediaUrls(mediaurls);
    priceFormatted =
        "${AppSettings.currencyIcon} ${Helper.formatNumber(num.tryParse("$price") ?? 0)}";
    try {
      foodType = (meta as Map)["food_type"];
    } catch (e) {
      print("setup-foodtype: $e");
    }
    if (addon_groups?.isNotEmpty ?? false) {
      addon_groups!.sort((a, b) => a.min_choices.compareTo(b.min_choices));
      for (ProductGroup group in addon_groups!) {
        addOnChoicesIsMust ??= group.min_choices > 0;
        if (group.addon_choices.isNotEmpty) {
          for (ProductGroupChoice choice in group.addon_choices) {
            choice.setup();
          }
        }
      }
    }
    if (vendor_products?.isNotEmpty ?? false) {
      for (VendorProduct vp in vendor_products!) {
        sale_price = vp.sale_price;
        stockQuantity = vp.stock_quantity;
        vp.setup();
      }
      priceSaleFormatted =
          "${AppSettings.currencyIcon} ${Helper.formatNumber(num.tryParse("$sale_price") ?? 0)}";
    }
    for (Category category in (categories ?? [])) {
      category.setup();
    }
    // quantity = CartManager()
    //     .getCartProductQuantity(vendor_products?.firstOrNull?.id ?? id);
  }
}
