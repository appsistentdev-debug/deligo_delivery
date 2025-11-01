part of 'chat_cubit.dart';

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatsLoading extends ChatState {
  const ChatsLoading();
}

class MessagesLoading extends ChatState {
  const MessagesLoading();
}

class ChatsProcessing extends ChatState {
  const ChatsProcessing();
}

class MessagesProcessing extends ChatState {
  const MessagesProcessing();
}

class MessageSending extends ChatState {
  const MessageSending();
}

class MessageSent extends ChatState {
  const MessageSent();
}

class MessageSendingFail extends ChatState {
  final String message, messageKey;

  const MessageSendingFail(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageSendingFail &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;
}

class ChatsLoaded extends ChatState {
  final List<Chat> chats;
  const ChatsLoaded(this.chats);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatsLoaded && foundation.listEquals(other.chats, chats);
  }

  @override
  int get hashCode => chats.hashCode;
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  const MessagesLoaded(this.messages);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessagesLoaded &&
        foundation.listEquals(other.messages, messages);
  }

  @override
  int get hashCode => messages.hashCode;
}

class ChatsFail extends ChatState {
  final String message, messageKey;

  const ChatsFail(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatsFail &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;
}

//MOTHER STATE
abstract class ChatState {
  const ChatState();
}
