// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/utility/helper.dart';

import 'category.dart';
import 'user_data.dart';

part 'vendor.g.dart';

@JsonSerializable()
class Vendor {
  final int id;
  final String name;
  final String? tagline;
  final String? details;
  final dynamic meta;
  final dynamic mediaurls;
  final int minimum_order;
  final double delivery_fee;
  final String? area;
  final String? address;
  final double longitude;
  final double latitude;
  final int is_verified;
  final int user_id;
  final String created_at;
  final String updated_at;
  final double? ratings;
  final int? ratings_count;
  final int? favourite_count;
  final bool? is_favourite;
  final double? distance;
  final List<Category>? categories;
  final List<Category>? product_categories;
  final UserData? user;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? imageUrl;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? distanceFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? ratingsFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? preperationTime;

  Vendor(
      this.id,
      this.name,
      this.tagline,
      this.details,
      this.meta,
      this.mediaurls,
      this.minimum_order,
      this.delivery_fee,
      this.area,
      this.address,
      this.longitude,
      this.latitude,
      this.is_verified,
      this.user_id,
      this.created_at,
      this.updated_at,
      this.ratings,
      this.ratings_count,
      this.favourite_count,
      this.is_favourite,
      this.distance,
      this.categories,
      this.product_categories,
      this.user);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vendor && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

  Map<String, dynamic> toJson() => _$VendorToJson(this);

  static Vendor get placeholder => Vendor(
      -1,
      "name",
      null,
      null,
      null,
      null,
      -1,
      -1,
      null,
      null,
      -1,
      -1,
      -1,
      -1,
      "created_at",
      "updated_at",
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null);

  void setup() {
    imageUrl = Helper.getMediaUrl(mediaurls);
    distanceFormatted = Helper.formatDistanceString(
      distanceInMeters: distance ?? 0,
      distanceMetric: AppSettings.distanceMetric,
    );
    ratingsFormatted = Helper.formatNumber(num.tryParse("$ratings") ?? 0);
    if (categories?.isNotEmpty ?? false) {
      for (Category r in categories!) {
        r.setup();
      }
    }
    if (product_categories?.isNotEmpty ?? false) {
      for (Category r in product_categories!) {
        r.setup();
      }
    }

    try {
      preperationTime = (meta as Map)["time"] ?? "0";
    } catch (e) {
      // ignore: avoid_print
      print("meta: $e");
    } finally {
      preperationTime ??= "0";
    }
  }
}
