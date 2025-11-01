import 'package:json_annotation/json_annotation.dart';

import 'user_data.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  String token;
  UserData user;

  AuthResponse(this.token, this.user);

  /// A necessary factory constructor for creating a new AuthResponse instance
  /// from a map. Pass the map to the generated `_$AuthResponseFromJson()` constructor.
  /// The constructor is named after the source class, in this case, AuthResponse.
  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AuthResponseToJson`.
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
