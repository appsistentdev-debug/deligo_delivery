import 'package:json_annotation/json_annotation.dart';

part 'notifications_summary.g.dart';

@JsonSerializable()
class NotificationsSummary {
  final int? count;

  NotificationsSummary(this.count);

  /// A necessary factory constructor for creating a new NotificationsSummary instance
  /// from a map. Pass the map to the generated `_$NotificationsSummaryFromJson()` constructor.
  /// The constructor is named after the source class, in this case, NotificationsSummary.
  factory NotificationsSummary.fromJson(Map<String, dynamic> json) =>
      _$NotificationsSummaryFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$NotificationsSummaryToJson`.
  Map<String, dynamic> toJson() => _$NotificationsSummaryToJson(this);
}
