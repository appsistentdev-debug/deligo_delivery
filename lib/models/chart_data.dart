// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:json_annotation/json_annotation.dart';

part 'chart_data.g.dart';

@JsonSerializable()
class ChartData {
  @JsonKey(name: 'period')
  final dynamic periodDynamic;
  @JsonKey(name: 'total')
  final dynamic totalDynamic;

  ChartData(
    this.periodDynamic,
    this.totalDynamic,
  );

  factory ChartData.fromJson(Map<String, dynamic> json) =>
      _$ChartDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChartDataToJson(this);

  String get period => "$periodDynamic";
  String get total => "$totalDynamic";
}
