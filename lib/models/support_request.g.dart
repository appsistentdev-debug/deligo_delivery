// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportRequest _$SupportRequestFromJson(Map<String, dynamic> json) =>
    SupportRequest(
      json['name'] as String,
      json['email'] as String,
      json['message'] as String,
    );

Map<String, dynamic> _$SupportRequestToJson(SupportRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'message': instance.message,
    };
