// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_to_bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendToBank _$SendToBankFromJson(Map<String, dynamic> json) => SendToBank(
      json['bank_name'] as String,
      json['bank_account_name'] as String,
      json['bank_account_number'] as String,
      json['bank_code'] as String,
      (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$SendToBankToJson(SendToBank instance) =>
    <String, dynamic>{
      'bank_name': instance.bankName,
      'bank_account_name': instance.bankAccountName,
      'bank_account_number': instance.bankAccountNumber,
      'bank_code': instance.bankCode,
      'amount': instance.amount,
    };
