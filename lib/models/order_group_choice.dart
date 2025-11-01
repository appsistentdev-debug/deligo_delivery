// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'product_group_choice.dart';

part 'order_group_choice.g.dart';

@JsonSerializable()
class OrderGroupChoice {
  final int id;
  final ProductGroupChoice addon_choice;

  OrderGroupChoice(this.id, this.addon_choice);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderGroupChoice && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory OrderGroupChoice.fromJson(Map<String, dynamic> json) =>
      _$OrderGroupChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$OrderGroupChoiceToJson(this);
}
