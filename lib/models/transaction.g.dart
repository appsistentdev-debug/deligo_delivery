// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      json['id'],
      json['amount'],
      json['type'] as String?,
      json['meta'],
      json['created_at'] as String,
      json['updated_at'] as String,
      UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.dynamicId,
      'amount': instance.dynamicAmount,
      'type': instance.type,
      'meta': instance.meta,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'user': instance.user,
    };
