// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaList _$MetaListFromJson(Map<String, dynamic> json) => MetaList(
      (json['current_page'] as num?)?.toInt(),
      (json['from'] as num?)?.toInt(),
      (json['last_page'] as num?)?.toInt(),
      json['path'] as String?,
      (json['per_page'] as num?)?.toInt(),
      (json['to'] as num?)?.toInt(),
      (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MetaListToJson(MetaList instance) => <String, dynamic>{
      'current_page': instance.current_page,
      'from': instance.from,
      'last_page': instance.last_page,
      'path': instance.path,
      'per_page': instance.per_page,
      'to': instance.to,
      'total': instance.total,
    };
