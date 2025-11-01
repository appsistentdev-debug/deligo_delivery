// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

import 'rating_summary.dart';

part 'rating.g.dart';

@JsonSerializable()
class Rating {
  @JsonKey(name: 'average_rating')
  final double? averageRating;
  @JsonKey(name: 'total_ratings')
  final int? totalRatings;
  List<RatingSummary> summary;

  Rating(this.averageRating, this.totalRatings, this.summary);

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
