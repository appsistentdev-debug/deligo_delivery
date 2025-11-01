// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map json) => Payment(
      (json['id'] as num).toInt(),
      (json['payable_id'] as num).toInt(),
      (json['amount'] as num).toDouble(),
      json['status'] as String,
      json['payment_method'] == null
          ? null
          : PaymentMethod.fromJson(
              Map<String, dynamic>.from(json['payment_method'] as Map)),
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'payable_id': instance.payableId,
      'amount': instance.amount,
      'status': instance.status,
      'payment_method': instance.paymentMethod?.toJson(),
    };
