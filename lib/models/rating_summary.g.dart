// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingSummary _$RatingSummaryFromJson(Map<String, dynamic> json) =>
    RatingSummary(
      (json['total'] as num).toInt(),
      (json['rounded_rating'] as num).toInt(),
    );

Map<String, dynamic> _$RatingSummaryToJson(RatingSummary instance) =>
    <String, dynamic>{
      'total': instance.total,
      'rounded_rating': instance.roundedRating,
    };
