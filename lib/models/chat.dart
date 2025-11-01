import 'package:deligo_delivery/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

import 'message.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  String? chatId;
  String? myId;
  String? dateTimeStamp;
  String? timeDiff;
  String? lastMessage;
  String? chatName;
  String? chatImage;
  String? chatStatus;
  bool? isGroup;
  bool? isRead;

  Chat({
    this.chatId,
    this.myId,
    this.dateTimeStamp,
    this.timeDiff,
    this.lastMessage,
    this.chatName,
    this.chatImage,
    this.chatStatus,
    this.isGroup,
    this.isRead,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  @override
  String toString() {
    return 'Chat(chatId: $chatId, myId: $myId, dateTimeStamp: $dateTimeStamp, timeDiff: $timeDiff, lastMessage: $lastMessage, chatName: $chatName, chatImage: $chatImage, chatStatus: $chatStatus, isGroup: $isGroup, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chat && other.chatId == chatId;
  }

  @override
  int get hashCode {
    return chatId.hashCode;
  }

  static Chat fromMessage(Message msg, bool isMeSender) {
    return Chat(
      chatId: isMeSender ? msg.recipientId : msg.senderId,
      myId: isMeSender ? msg.senderId : msg.recipientId,
      chatName: isMeSender ? msg.recipientName : msg.senderName,
      chatImage: isMeSender ? msg.recipientImage : msg.senderImage,
      chatStatus: isMeSender ? msg.recipientStatus : msg.senderStatus,
      lastMessage: msg.attachment == null
          ? msg.body
          : "attachment_type_${msg.attachment!.type}",
      dateTimeStamp: msg.dateTimeStamp,
      timeDiff: Helper.setupDateTimeFromMillis(
          int.parse(msg.dateTimeStamp!), false, true),
    );
  }

  static String extractChaterUserId(String chaterId, String role) =>
      chaterId.substring(0, chaterId.indexOf(role));
}
