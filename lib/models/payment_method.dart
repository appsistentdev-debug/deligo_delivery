import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_method.g.dart';

@JsonSerializable()
class PaymentMethod {
  final int? id;
  final int? enabled;
  final String? slug;
  final String? title;
  final String? type;
  @JsonKey(name: 'meta')
  final dynamic dynamicMeta;

  PaymentMethod(this.id, this.enabled, this.slug, this.title, this.type,
      this.dynamicMeta);

  /// A necessary factory constructor for creating a new PaymentMethod instance
  /// from a map. Pass the map to the generated `_$PaymentMethodFromJson()` constructor.
  /// The constructor is named after the source class, in this case, PaymentMethod.
  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PaymentMethodToJson`.
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);

  String? getMetaKey(String key) {
    //key: public_key or private_key
    String? toReturn;
    if (meta != null) {
      try {
        Map metaMap = jsonDecode(meta!);
        if (metaMap.containsKey(key)) toReturn = metaMap[key];
      } catch (e) {
        if (kDebugMode) {
          print("key: $key getMetaKey: $e");
        }
      }
    }
    return toReturn;
  }

  String? get meta {
    return (dynamicMeta != null && dynamicMeta is String) ? dynamicMeta : null;
  }
}
