import 'package:json_annotation/json_annotation.dart';
import 'package:deligo_delivery/utility/constants.dart';

part 'auth_request_login_social.g.dart';

@JsonSerializable()
class AuthRequestLoginSocial {
  late String platform;
  late String token;
  late String os;
  late String role;

  AuthRequestLoginSocial(this.platform, this.token, this.os) {
    role = Constants.roleDriver;
  }

  /// A necessary factory constructor for creating a new AuthRequestLoginSocial instance
  /// from a map. Pass the map to the generated `_$AuthRequestLoginSocialFromJson()` constructor.
  /// The constructor is named after the source class, in this case, AuthRequestLoginSocial.
  factory AuthRequestLoginSocial.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestLoginSocialFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AuthRequestLoginSocialToJson`.
  Map<String, dynamic> toJson() => _$AuthRequestLoginSocialToJson(this);
}
