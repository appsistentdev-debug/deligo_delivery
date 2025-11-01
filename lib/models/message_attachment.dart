import 'package:json_annotation/json_annotation.dart';

part 'message_attachment.g.dart';

@JsonSerializable()
class MessageAttachment {
  String? type;
  String? url;
  String? subUrl;

  MessageAttachment({
    this.type,
    this.url,
    this.subUrl,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) =>
      _$MessageAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$MessageAttachmentToJson(this);

  static const String attachmentTypeDocument = "document";
  static const String attachmentTypeVideo = "video";
  static const String attachmentTypeImage = "image";
}
