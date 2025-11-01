// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageAttachment _$MessageAttachmentFromJson(Map<String, dynamic> json) =>
    MessageAttachment(
      type: json['type'] as String?,
      url: json['url'] as String?,
      subUrl: json['subUrl'] as String?,
    );

Map<String, dynamic> _$MessageAttachmentToJson(MessageAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'url': instance.url,
      'subUrl': instance.subUrl,
    };
