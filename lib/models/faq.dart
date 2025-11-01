// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'faq.g.dart';

@JsonSerializable()
class Faq {
  final int id;
  final String title, short_description, description;
  final dynamic meta;

  Faq(this.id, this.title, this.short_description, this.description, this.meta);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Faq && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Faq.fromJson(Map<String, dynamic> json) => _$FaqFromJson(json);

  Map<String, dynamic> toJson() => _$FaqToJson(this);
}
