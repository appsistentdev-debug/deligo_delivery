import 'package:json_annotation/json_annotation.dart';

import 'message_attachment.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  String? senderName;
  String? senderImage;
  String? senderStatus;
  String? recipientName;
  String? recipientImage;
  String? recipientStatus;
  String? recipientId;
  String? senderId;
  String? chatId;
  String? id;
  String? timeDiff;
  String? body;
  String? dateTimeStamp;
  bool? delivered;
  bool? sent;
  MessageAttachment? attachment;
  Message({
    this.senderName,
    this.senderImage,
    this.senderStatus,
    this.recipientName,
    this.recipientImage,
    this.recipientStatus,
    this.recipientId,
    this.senderId,
    this.chatId,
    this.id,
    this.timeDiff,
    this.body,
    this.dateTimeStamp,
    this.delivered,
    this.sent,
    this.attachment,
  });
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  String toString() {
    return 'Message(senderName: $senderName, senderImage: $senderImage, senderStatus: $senderStatus, recipientName: $recipientName, recipientImage: $recipientImage, recipientStatus: $recipientStatus, recipientId: $recipientId, senderId: $senderId, chatId: $chatId, id: $id, timeDiff: $timeDiff, body: $body, dateTimeStamp: $dateTimeStamp, delivered: $delivered, sent: $sent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
