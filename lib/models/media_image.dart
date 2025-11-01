import 'package:json_annotation/json_annotation.dart';

part 'media_image.g.dart';

@JsonSerializable()
class MediaImage {
  @JsonKey(name: 'default')
  final String? defaultImage;
  final String? thumb;
  final String? small;
  final String? medium;
  final String? large;

  MediaImage(
      this.defaultImage, this.thumb, this.small, this.medium, this.large);

  /// A necessary factory constructor for creating a new MediaImage instance
  /// from a map. Pass the map to the generated `_$MediaImageFromJson()` constructor.
  /// The constructor is named after the source class, in this case, MediaImage.
  factory MediaImage.fromJson(Map<String, dynamic> json) =>
      _$MediaImageFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$MediaImageToJson`.
  Map<String, dynamic> toJson() => _$MediaImageToJson(this);
}

enum MediaImageSize { thumb, small, medium, large }
