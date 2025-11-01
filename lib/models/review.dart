// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';
import 'package:deligo_delivery/utility/helper.dart';

import 'user_data.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  final int? id;
  final int? rating;
  final String? review;
  final UserData user;
  final String? created_at;
  final dynamic meta;

  String? created_at_formatted;
  String? categoryTitle;

  Review(
      this.id, this.rating, this.review, this.user, this.created_at, this.meta);

  void setup() {
    created_at_formatted = Helper.setupDate(created_at!, true);
    user.setup();
    if (meta != null &&
        meta is Map &&
        (meta as Map).containsKey("category") &&
        (meta as Map)["category"].containsKey("title")) {
      categoryTitle = meta["category"]["title"];
    }
  }

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
