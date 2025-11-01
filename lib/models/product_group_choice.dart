// ignore_for_file: non_constant_identifier_names

import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_group_choice.g.dart';

@JsonSerializable()
class ProductGroupChoice {
  final int id;
  final String title;
  final double price;
  final int product_addon_group_id;
  final String created_at;
  final String updated_at;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? priceFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? selected;

  ProductGroupChoice(this.id, this.title, this.price,
      this.product_addon_group_id, this.created_at, this.updated_at);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductGroupChoice && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory ProductGroupChoice.fromJson(Map<String, dynamic> json) =>
      _$ProductGroupChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$ProductGroupChoiceToJson(this);

  void setup() {
    priceFormatted =
        "${AppSettings.currencyIcon} ${Helper.formatNumber(num.tryParse("$price") ?? 0)}";
  }
}
