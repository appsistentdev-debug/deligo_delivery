// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      chatId: json['chatId'] as String?,
      myId: json['myId'] as String?,
      dateTimeStamp: json['dateTimeStamp'] as String?,
      timeDiff: json['timeDiff'] as String?,
      lastMessage: json['lastMessage'] as String?,
      chatName: json['chatName'] as String?,
      chatImage: json['chatImage'] as String?,
      chatStatus: json['chatStatus'] as String?,
      isGroup: json['isGroup'] as bool?,
      isRead: json['isRead'] as bool?,
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'chatId': instance.chatId,
      'myId': instance.myId,
      'dateTimeStamp': instance.dateTimeStamp,
      'timeDiff': instance.timeDiff,
      'lastMessage': instance.lastMessage,
      'chatName': instance.chatName,
      'chatImage': instance.chatImage,
      'chatStatus': instance.chatStatus,
      'isGroup': instance.isGroup,
      'isRead': instance.isRead,
    };
