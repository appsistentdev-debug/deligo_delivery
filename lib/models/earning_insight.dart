import 'package:json_annotation/json_annotation.dart';

import 'chart_data.dart';

part 'earning_insight.g.dart';

@JsonSerializable()
class EarningInsight {
  @JsonKey(name: 'total_earnings')
  final dynamic totalEarningsDynamic;

  @JsonKey(name: 'earnings_chart_data')
  final List<ChartData> chartData;

  EarningInsight(this.totalEarningsDynamic, this.chartData);

  factory EarningInsight.fromJson(Map<String, dynamic> json) =>
      _$EarningInsightFromJson(json);

  Map<String, dynamic> toJson() => _$EarningInsightToJson(this);

  String get totalEarnings => (totalEarningsDynamic.runtimeType is double
          ? totalEarningsDynamic
          : double.tryParse("$totalEarningsDynamic") ?? 0.0)
      .toStringAsFixed(2);

  static EarningInsight getDefault() => EarningInsight(0, [
        ChartData("0", "0"),
        ChartData("0", "0"),
        ChartData("0", "0"),
        ChartData("0", "0"),
        ChartData("0", "0")
      ]);

  static Map<String, String> getRequest(String duration) {
    switch (duration) {
      case "today":
        return {"duration": "hours", "limit": "${DateTime.now().hour}"};
      case "weekly":
        return {"duration": "days", "limit": "7"};
      case "monthly":
        return {"duration": "months", "limit": "12"};
      default:
        return {"duration": "years", "limit": "12"};
    }
  }
}
