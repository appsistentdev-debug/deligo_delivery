// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaUrl _$MediaUrlFromJson(Map<String, dynamic> json) => MediaUrl(
      (json['images'] as List<dynamic>?)
          ?.map((e) => MediaImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MediaUrlToJson(MediaUrl instance) => <String, dynamic>{
      'images': instance.images,
    };
