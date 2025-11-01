// ignore_for_file: non_constant_identifier_names
import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:deligo_delivery/utility/constants.dart';

part 'auth_request_register.g.dart';

@JsonSerializable()
class AuthRequestRegister {
  late String name;
  late String email;
  late String password;
  late String mobile_number;
  String? image_url;
  late String role;

  AuthRequestRegister(this.name, this.email, String? password,
      this.mobile_number, this.image_url) {
    this.password = (password != null && password.isNotEmpty)
        ? password
        : (Random().nextInt(9000) + 1000).toString();
    role = Constants.roleDriver;
  }

  /// A necessary factory constructor for creating a new AuthRequestRegister instance
  /// from a map. Pass the map to the generated `_$AuthRequestRegisterFromJson()` constructor.
  /// The constructor is named after the source class, in this case, AuthRequestRegister.
  factory AuthRequestRegister.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestRegisterFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AuthRequestRegisterToJson`.
  Map<String, dynamic> toJson() => _$AuthRequestRegisterToJson(this);
}
