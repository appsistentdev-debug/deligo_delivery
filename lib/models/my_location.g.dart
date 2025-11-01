// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyLocation _$MyLocationFromJson(Map<String, dynamic> json) => MyLocation(
      (json['lattitude'] as num?)?.toDouble(),
      (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MyLocationToJson(MyLocation instance) =>
    <String, dynamic>{
      'lattitude': instance.lattitude,
      'longitude': instance.longitude,
    };
