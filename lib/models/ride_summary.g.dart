// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RideSummary _$RideSummaryFromJson(Map<String, dynamic> json) => RideSummary(
      (json['orders_count'] as num?)?.toInt(),
      (json['rides_count'] as num?)?.toInt(),
      json['earnings'],
      json['distance_travelled'],
      (json['orders_chart_data'] as List<dynamic>?)
          ?.map((e) => ChartData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RideSummaryToJson(RideSummary instance) =>
    <String, dynamic>{
      'orders_count': instance.ordersCount,
      'rides_count': instance.ridesCount,
      'earnings': instance.earningsDynamic,
      'distance_travelled': instance.distanceTravelledDynamic,
      'orders_chart_data': instance.chartData,
    };
