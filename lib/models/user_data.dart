// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:deligo_delivery/utility/helper.dart';

import 'wallet.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  late int id;
  late String name;
  late String email;
  String? language;
  dynamic mediaurls;
  int? active;
  int? confirmed;
  int? mobile_verified;
  late String mobile_number;
  Wallet? wallet;
  dynamic meta;

  String? imageUrl;

  UserData(
      this.id,
      this.name,
      this.email,
      this.language,
      this.mediaurls,
      this.active,
      this.confirmed,
      this.mobile_verified,
      this.mobile_number,
      this.wallet,
      this.meta);

  @override
  String toString() {
    return 'UserData{id: $id, name: $name, email: $email, language: $language, mediaurls: $mediaurls, active: $active, confirmed: $confirmed, mobile_verified: $mobile_verified, mobile_number: $mobile_number}';
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  void setup() {
    imageUrl = Helper.getMediaUrl(mediaurls);
  }
}
