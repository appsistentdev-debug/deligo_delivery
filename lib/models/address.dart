// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  final int id;
  String? title;
  String formatted_address;
  double longitude;
  double latitude;
  final String? type;
  final String? address1;
  final String? address2;
  final String? country;
  final String? state;
  final String? city;
  final String? postcode;
  final dynamic meta;

  Address(
      this.id,
      this.title,
      this.formatted_address,
      this.longitude,
      this.latitude,
      this.type,
      this.address1,
      this.address2,
      this.country,
      this.state,
      this.city,
      this.postcode,
      this.meta);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Address && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
