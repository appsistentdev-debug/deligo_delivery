import 'package:json_annotation/json_annotation.dart';

import 'media_image.dart';

part 'media_url.g.dart';

@JsonSerializable()
class MediaUrl {
  List<MediaImage>? images;

  MediaUrl(this.images);

  /// A necessary factory constructor for creating a new MediaUrl instance
  /// from a map. Pass the map to the generated `_$MediaUrlFromJson()` constructor.
  /// The constructor is named after the source class, in this case, MediaUrl.
  factory MediaUrl.fromJson(Map<String, dynamic> json) =>
      _$MediaUrlFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$MediaUrlToJson`.
  Map<String, dynamic> toJson() => _$MediaUrlToJson(this);
}
