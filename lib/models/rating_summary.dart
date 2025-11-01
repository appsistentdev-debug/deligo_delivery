// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rating_summary.g.dart';

@JsonSerializable()
class RatingSummary {
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'rounded_rating')
  final int roundedRating;
  @JsonKey(includeToJson: false, includeFromJson: false)
  double? percent;
  @JsonKey(includeToJson: false, includeFromJson: false)
  Color? color;

  static List<Color> get pieChartColors => [
        Colors.red,
        Colors.orange.shade700,
        Colors.yellow.shade700,
        Colors.blue,
        Colors.green,
      ];

  RatingSummary(this.total, this.roundedRating);

  factory RatingSummary.fromJson(Map<String, dynamic> json) =>
      _$RatingSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$RatingSummaryToJson(this);
}
