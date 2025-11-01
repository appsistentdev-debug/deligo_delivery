// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNotification _$UserNotificationFromJson(Map<String, dynamic> json) =>
    UserNotification(
      (json['id'] as num).toInt(),
      json['text'] as String,
      json['created_at'] as String,
      UserData.fromJson(json['user'] as Map<String, dynamic>),
      UserData.fromJson(json['fromuser'] as Map<String, dynamic>),
      json['meta'],
    )
      ..created_at_formatted = json['created_at_formatted'] as String?
      ..categoryTitle = json['categoryTitle'] as String?;

Map<String, dynamic> _$UserNotificationToJson(UserNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'created_at': instance.created_at,
      'user': instance.user,
      'fromuser': instance.fromuser,
      'meta': instance.meta,
      'created_at_formatted': instance.created_at_formatted,
      'categoryTitle': instance.categoryTitle,
    };
