import 'package:json_annotation/json_annotation.dart';

import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/utility/string_extensions.dart';

import 'chart_data.dart';

part 'ride_summary.g.dart';

@JsonSerializable()
class RideSummary {
  @JsonKey(name: 'orders_count')
  final int? ordersCount;
  @JsonKey(name: 'rides_count')
  final int? ridesCount;
  @JsonKey(name: 'earnings')
  final dynamic earningsDynamic;
  @JsonKey(name: 'distance_travelled')
  final dynamic distanceTravelledDynamic;

  @JsonKey(name: 'orders_chart_data')
  final List<ChartData>? chartData;

  RideSummary(this.ordersCount, this.ridesCount, this.earningsDynamic,
      this.distanceTravelledDynamic, this.chartData);

  factory RideSummary.fromJson(Map<String, dynamic> json) =>
      _$RideSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$RideSummaryToJson(this);

  String get earnings =>
      (double.tryParse("$earningsDynamic") ?? 0.0).toStringAsFixed(2);

  String get distanceTravelledFormatted =>
      "${(double.tryParse("$distanceTravelledDynamic") ?? 0.0).toStringAsFixed(2)} ${AppSettings.distanceMetric.capitalizeFirst()}";

  static RideSummary getDefault() => RideSummary(0, 0, 0, 0, [
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
