import 'package:json_annotation/json_annotation.dart';

part 'support_request.g.dart';

@JsonSerializable()
class SupportRequest {
  final String name;
  final String email;
  final String message;

  SupportRequest(this.name, this.email, this.message);

  /// A necessary factory constructor for creating a new SupportRequest instance
  /// from a map. Pass the map to the generated `_$SupportRequestFromJson()` constructor.
  /// The constructor is named after the source class, in this case, SupportRequest.
  factory SupportRequest.fromJson(Map<String, dynamic> json) =>
      _$SupportRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$SupportRequestToJson`.
  Map<String, dynamic> toJson() => _$SupportRequestToJson(this);
}
