// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      (json['id'] as num?)?.toInt(),
      (json['rating'] as num?)?.toInt(),
      json['review'] as String?,
      UserData.fromJson(json['user'] as Map<String, dynamic>),
      json['created_at'] as String?,
      json['meta'],
    )
      ..created_at_formatted = json['created_at_formatted'] as String?
      ..categoryTitle = json['categoryTitle'] as String?;

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'review': instance.review,
      'user': instance.user,
      'created_at': instance.created_at,
      'meta': instance.meta,
      'created_at_formatted': instance.created_at_formatted,
      'categoryTitle': instance.categoryTitle,
    };
