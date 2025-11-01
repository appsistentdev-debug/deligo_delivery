import 'dart:async';
import 'dart:convert';

import 'package:deligo_delivery/models/chat.dart';
import 'package:deligo_delivery/models/message.dart';
import 'package:deligo_delivery/models/message_attachment.dart';
import 'package:deligo_delivery/models/user_data.dart';
import 'package:deligo_delivery/network/remote_repository.dart';
import 'package:deligo_delivery/utility/constants.dart';
import 'package:deligo_delivery/utility/helper.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' as foundation;

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  DatabaseReference? _chatRef, _inboxRef;
  UserData? _userMe;
  String? _mySenderId;
  final List<Chat> _chats = [];
  final List<Message> _messages = [];

  StreamSubscription<DatabaseEvent>? _inboxAddedStreamSubscription,
      _inboxChangedStreamSubscription,
      _chatAddedStreamSubscription;

  ChatCubit() : super(const ChatInitial());

  @override
  Future<void> close() async {
    await _unRegisterAllUpdates();
    return super.close();
  }

  Future<void> initFetchChats() async {
    emit(const ChatsLoading());
    try {
      await _setupUserMe();
      _setupFirebaseRef();
      _inboxAddedStreamSubscription ??= _inboxRef!
          .child(_mySenderId!)
          .onChildAdded
          .listen((DatabaseEvent event) => _handleFireInboxAddedEvent(event));
      _inboxChangedStreamSubscription ??= _inboxRef!
          .child(_mySenderId!)
          .onChildChanged
          .listen((DatabaseEvent event) => _handleFireInboxChangedEvent(event));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchChats: $e");
      }
      emit(const ChatsFail("Something went wrong", "something_wrong"));
    }
  }

  Future<void> initFetchChatMessages(Chat chat) async {
    emit(const MessagesLoading());
    await _setupUserMe(true);
    _setupFirebaseRef();
    _chatAddedStreamSubscription = _chatRef!
        .child(_getChatChild(chat.myId!, chat.chatId!))
        .limitToLast(50)
        .onChildAdded
        .listen((DatabaseEvent event) => _handleFireChatAddedEvent(event));
  }

  Future<void> initSendChatMessageText(Chat chat, String msgBody) async {
    emit(const MessageSending());
    try {
      await _setupUserMe();
      _setupFirebaseRef();
      Message message = _prepareMessage(chat);
      message.id = _chatRef!.child(message.chatId!).push().key;
      message.body = msgBody;
      await _sendMessage(message);
      emit(const MessageSent());
      await _notifyMessage(message.recipientId!);
    } catch (e) {
      if (kDebugMode) {
        print("initSendChatMessageText: $e");
      }
      emit(const MessageSendingFail("Something went wrong", "something_wrong"));
    }
  }

  Future<void> initSendChatMessageAttachment(
      Chat chat, MessageAttachment messageAttachment) async {
    emit(const MessageSending());
    try {
      await _setupUserMe();
      _setupFirebaseRef();
      Message message = _prepareMessage(chat);
      message.id = _chatRef!.child(message.chatId!).push().key;
      message.attachment = messageAttachment;
      await _sendMessage(message);
      emit(const MessageSent());
      await _notifyMessage(message.recipientId!);
    } catch (e) {
      if (kDebugMode) {
        print("initSendChatMessageAttachment: $e");
      }
      emit(const MessageSendingFail("Something went wrong", "something_wrong"));
    }
  }

  Future<void> unRegisterChats() async {
    await _inboxAddedStreamSubscription?.cancel();
    _inboxAddedStreamSubscription = null;
    await _inboxChangedStreamSubscription?.cancel();
    _inboxChangedStreamSubscription = null;
    _chats.clear();
    _userMe = null;
  }

  Future<void> unRegisterChatMessages() async {
    await _chatAddedStreamSubscription?.cancel();
    _chatAddedStreamSubscription = null;
    _messages.clear();
  }

  Future<void> _handleFireChatAddedEvent(DatabaseEvent event) async {
    if (event.snapshot.value != null) {
      try {
        Map resultMap = event.snapshot.value as Map;
        Map<String, dynamic> json = {};
        for (String key in resultMap.keys) {
          json[key] = key == "attachment"
              ? jsonDecode(jsonEncode(resultMap[key]))
              : resultMap[key];
        }
        Message newMessage = Message.fromJson(json);
        emit(const MessagesProcessing());
        newMessage.timeDiff = Helper.setupDateTimeFromMillis(
            int.parse(newMessage.dateTimeStamp!), false, true);
        if (newMessage.senderId != _mySenderId) {
          newMessage.delivered = true;
          _chatRef!
              .child(newMessage.chatId!)
              .child(newMessage.id!)
              .child("delivered")
              .set(true);
        }
        _messages.add(newMessage);
        emit(MessagesLoaded(_messages));
      } catch (e) {
        if (kDebugMode) {
          print("handleFireChatAddedEvent: $e");
        }
        emit(const ChatsFail("Something went wrong", "something_wrong"));
      }
    }
  }

  Future<void> _handleFireInboxAddedEvent(DatabaseEvent event) async {
    if (event.snapshot.value != null) {
      try {
        Map resultMap = event.snapshot.value as Map;
        Map<String, dynamic> json = {};
        for (String key in resultMap.keys) {
          json[key] = key == "attachment"
              ? jsonDecode(jsonEncode(resultMap[key]))
              : resultMap[key];
        }
        Message newMessage = Message.fromJson(json);
        Chat chat =
            Chat.fromMessage(newMessage, newMessage.senderId == _mySenderId);
        chat.isRead = await LocalDataLayer().addIfChatUnread(chat);
        _chats.add(chat);
        emit(const ChatsProcessing());
        _chats.sort((one, two) =>
            (int.parse(one.dateTimeStamp!) > int.parse(two.dateTimeStamp!)
                ? -1
                : 1));
        emit(ChatsLoaded(_chats));
      } catch (e) {
        if (kDebugMode) {
          print("handleFireAddedEvent: $e");
        }
        emit(const ChatsFail("Something went wrong", "something_wrong"));
      }
    }
  }

  Future<void> _handleFireInboxChangedEvent(DatabaseEvent event) async {
    if (event.snapshot.value != null) {
      try {
        Map resultMap = event.snapshot.value as Map;
        Map<String, dynamic> json = {};
        for (String key in resultMap.keys) {
          json[key] = key == "attachment"
              ? jsonDecode(jsonEncode(resultMap[key]))
              : resultMap[key];
        }
        Message newMessage = Message.fromJson(json);
        Chat chat =
            Chat.fromMessage(newMessage, newMessage.senderId == _mySenderId);
        chat.isRead = await LocalDataLayer().addIfChatUnread(chat);
        int existingIndex = _chats.indexOf(chat);
        if (existingIndex != -1) {
          emit(const ChatsProcessing());
          _chats.removeAt(existingIndex);
          _chats.insert(0, chat);
          emit(ChatsLoaded(_chats));
        }
      } catch (e) {
        if (kDebugMode) {
          print("handleFireChangedEvent: $e");
        }
        emit(const ChatsFail("Something went wrong", "something_wrong"));
      }
    }
  }

  Future<void> _unRegisterAllUpdates() async {
    await unRegisterChats();
    await unRegisterChatMessages();
  }

  Future<void> _setupUserMe([bool reload = false]) async {
    if (_userMe == null || reload) _userMe = await LocalDataLayer().getUserMe();
    _mySenderId = "${_userMe!.id}${Constants.roleDriver}";
  }

  void _setupFirebaseRef() {
    _inboxRef ??= FirebaseDatabase.instance.ref().child(Constants.refInbox);
    _chatRef ??= FirebaseDatabase.instance.ref().child(Constants.refChat);
  }

  String _getChatChild(String userId, String myId) {
    //example: userId="9" and myId="5" -->> chat child = "5-9"
    List<String> values = [userId, myId];
    values.sort();
    return "${values[0]}-${values[1]}";
  }

  Message _prepareMessage(Chat chat) => Message(
        chatId: _getChatChild(chat.myId!, chat.chatId!),
        dateTimeStamp: "${DateTime.now().millisecondsSinceEpoch}",
        delivered: false,
        sent: true,
        recipientId: chat.chatId,
        recipientImage: chat.chatImage,
        recipientName: chat.chatName,
        recipientStatus: chat.chatStatus,
        senderId: chat.myId,
        senderName: _userMe!.name,
        senderImage: _userMe!.imageUrl,
        senderStatus: _userMe!.email,
      );

  Future<void> _sendMessage(Message message) async {
    Map<String, dynamic> messageRequest = message.toJson();
    if (message.attachment != null) {
      messageRequest["attachment"] = message.attachment!.toJson();
    }
    await _chatRef!
        .child(message.chatId!)
        .child(message.id!)
        .set(messageRequest);
    await _inboxRef!
        .child(message.recipientId!)
        .child(message.senderId!)
        .set(messageRequest);
    await _inboxRef!
        .child(message.senderId!)
        .child(message.recipientId!)
        .set(messageRequest);
  }

  Future<void> _notifyMessage(String recipientId) async {
    try {
      String chatRole = recipientId.contains(Constants.roleDriver)
          ? Constants.roleDriver
          : Constants.roleUser;
      await RemoteRepository().postNotification(
        roleTo: chatRole,
        userIdTo: recipientId.substring(0, recipientId.indexOf(chatRole)),
      );
    } catch (e) {
      if (kDebugMode) {
        print("notifyMessage: $e");
      }
    }
  }
}
