import 'package:json_annotation/json_annotation.dart';

part 'my_location.g.dart';

@JsonSerializable()
class MyLocation {
  final double? lattitude, longitude;
  MyLocation(this.lattitude, this.longitude);
  factory MyLocation.fromJson(Map<String, dynamic> json) =>
      _$MyLocationFromJson(json);

  Map<String, dynamic> toJson() => _$MyLocationToJson(this);
}
