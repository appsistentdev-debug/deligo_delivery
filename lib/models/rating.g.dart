// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      (json['average_rating'] as num?)?.toDouble(),
      (json['total_ratings'] as num?)?.toInt(),
      (json['summary'] as List<dynamic>)
          .map((e) => RatingSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'average_rating': instance.averageRating,
      'total_ratings': instance.totalRatings,
      'summary': instance.summary,
    };
