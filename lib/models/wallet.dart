// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'wallet.g.dart';

@JsonSerializable()
class Wallet {
  final int? id;
  final int? user_id;
  final String? updated_at;
  @JsonKey(name: 'balance')
  final dynamic dynamicBalance;

  Wallet(this.id, this.user_id, this.dynamicBalance, this.updated_at);

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);

  double get balance => double.tryParse("$dynamicBalance") ?? 0;
}
