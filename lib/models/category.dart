// ignore_for_file: non_constant_identifier_names
import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:deligo_delivery/utility/helper.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final int id;
  final int? parent_id;
  final String? slug;
  final String title;
  final dynamic mediaurls;
  final dynamic meta;
  String? image_url;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? imageUrl;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? vendorType;

  Category(this.id, this.parent_id, this.slug, this.title, this.mediaurls,
      this.meta);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  void setupImageUrl() {
    image_url = Helper.getMediaUrl(mediaurls);
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  void setup() {
    imageUrl = Helper.getMediaUrl(mediaurls);
    List<String> vts =
        AppSettings.vendorType.split(",").map((e) => e.trim()).toList();
    vts.removeWhere((element) => element.isEmpty);
    for (String vt in vts) {
      if ((slug ?? "").contains(vt)) {
        vendorType = vt;
        break;
      }
    }
  }
}
