// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'product_group_choice.dart';

part 'product_group.g.dart';

@JsonSerializable()
class ProductGroup {
  final int id;
  final String title;
  final int max_choices;
  final int min_choices;
  final int product_id;
  final List<ProductGroupChoice> addon_choices;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int? choiceIdSelected;

  ProductGroup(this.id, this.title, this.max_choices, this.min_choices,
      this.product_id, this.addon_choices);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductGroup && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory ProductGroup.fromJson(Map<String, dynamic> json) =>
      _$ProductGroupFromJson(json);

  Map<String, dynamic> toJson() => _$ProductGroupToJson(this);
}
