import 'package:json_annotation/json_annotation.dart';

part 'rating_request.g.dart';

@JsonSerializable()
class RatingRequest {
  final int? rating;
  final String? review;
  final String? meta;

  RatingRequest(this.rating, this.review, this.meta);

  /// A necessary factory constructor for creating a new RatingRequest instance
  /// from a map. Pass the map to the generated `_$RatingRequestFromJson()` constructor.
  /// The constructor is named after the source class, in this case, RatingRequest.
  factory RatingRequest.fromJson(Map<String, dynamic> json) =>
      _$RatingRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$RatingRequestToJson`.
  Map<String, dynamic> toJson() => _$RatingRequestToJson(this);
}
