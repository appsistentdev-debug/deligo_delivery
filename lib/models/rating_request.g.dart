// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingRequest _$RatingRequestFromJson(Map<String, dynamic> json) =>
    RatingRequest(
      (json['rating'] as num?)?.toInt(),
      json['review'] as String?,
      json['meta'] as String?,
    );

Map<String, dynamic> _$RatingRequestToJson(RatingRequest instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'review': instance.review,
      'meta': instance.meta,
    };
