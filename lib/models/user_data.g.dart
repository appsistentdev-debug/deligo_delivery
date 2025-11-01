// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['email'] as String,
      json['language'] as String?,
      json['mediaurls'],
      (json['active'] as num?)?.toInt(),
      (json['confirmed'] as num?)?.toInt(),
      (json['mobile_verified'] as num?)?.toInt(),
      json['mobile_number'] as String,
      json['wallet'] == null
          ? null
          : Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
      json['meta'],
    )..imageUrl = json['imageUrl'] as String?;

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'language': instance.language,
      'mediaurls': instance.mediaurls,
      'active': instance.active,
      'confirmed': instance.confirmed,
      'mobile_verified': instance.mobile_verified,
      'mobile_number': instance.mobile_number,
      'wallet': instance.wallet,
      'meta': instance.meta,
      'imageUrl': instance.imageUrl,
    };
