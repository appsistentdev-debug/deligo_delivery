// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaImage _$MediaImageFromJson(Map<String, dynamic> json) => MediaImage(
      json['default'] as String?,
      json['thumb'] as String?,
      json['small'] as String?,
      json['medium'] as String?,
      json['large'] as String?,
    );

Map<String, dynamic> _$MediaImageToJson(MediaImage instance) =>
    <String, dynamic>{
      'default': instance.defaultImage,
      'thumb': instance.thumb,
      'small': instance.small,
      'medium': instance.medium,
      'large': instance.large,
    };
