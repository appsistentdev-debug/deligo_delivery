// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earning_insight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EarningInsight _$EarningInsightFromJson(Map<String, dynamic> json) =>
    EarningInsight(
      json['total_earnings'],
      (json['earnings_chart_data'] as List<dynamic>)
          .map((e) => ChartData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EarningInsightToJson(EarningInsight instance) =>
    <String, dynamic>{
      'total_earnings': instance.totalEarningsDynamic,
      'earnings_chart_data': instance.chartData,
    };
