import 'package:json_annotation/json_annotation.dart';

part 'send_to_bank.g.dart';

@JsonSerializable()
class SendToBank {
  @JsonKey(name: 'bank_name')
  final String bankName;
  @JsonKey(name: 'bank_account_name')
  final String bankAccountName;
  @JsonKey(name: 'bank_account_number')
  final String bankAccountNumber;
  @JsonKey(name: 'bank_code')
  final String bankCode;
  final double amount;

  SendToBank(
      this.bankName, this.bankAccountName, this.bankAccountNumber, this.bankCode, this.amount);

  factory SendToBank.fromJson(Map<String, dynamic> json) => _$SendToBankFromJson(json);

  Map<String, dynamic> toJson() => _$SendToBankToJson(this);
}
