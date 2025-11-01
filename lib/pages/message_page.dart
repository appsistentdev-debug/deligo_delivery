// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deligo_delivery/bloc/chat_cubit.dart';
import 'package:deligo_delivery/config/assets.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/chat.dart';
import 'package:deligo_delivery/models/message.dart';
import 'package:deligo_delivery/utility/helper.dart';
import 'package:deligo_delivery/widgets/cached_image.dart';
import 'package:deligo_delivery/widgets/entry_field.dart';
import 'package:deligo_delivery/widgets/toaster.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: MessageStateful(args["chat"], args["subtitle"]),
    );
  }
}

class MessageStateful extends StatefulWidget {
  final Chat chat;
  final String subtitle;
  const MessageStateful(this.chat, this.subtitle, {super.key});

  @override
  State<MessageStateful> createState() => _MessageStatefulState();
}

class _MessageStatefulState extends State<MessageStateful> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _newMessageController = TextEditingController();

  late ChatCubit _chatCubit;

  List<Message> _messages = [];

  @override
  void initState() {
    _chatCubit = BlocProvider.of<ChatCubit>(context);
    _chatCubit.initFetchChatMessages(widget.chat);
    super.initState();
  }

  @override
  void dispose() {
    _chatCubit.unRegisterChatMessages();
    _scrollController.dispose();
    _newMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is MessagesLoaded) {
          _messages = state.messages.reversed.toList();
          setState(() {});
          _scrollToBottom();
        }
        if (state is ChatsFail) {
          setState(() {});
        }
        if (state is MessageSendingFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey));
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              dense: true,
              // leading: Icon(
              //   Icons.assistant_navigation,
              //   color: theme.primaryColor,
              // ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedImage(
                  imageUrl: widget.chat.chatImage,
                  imagePlaceholder: Assets.emptyProfile,
                  height: 50,
                  width: 50,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.subtitle,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 12, color: Colors.grey, letterSpacing: 0.05),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.chat.chatName ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 16, letterSpacing: 0.07),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              trailing: FittedBox(
                fit: BoxFit.fill,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        border: Border.all(color: theme.cardColor, width: 2),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.call,
                          color: theme.primaryColor,
                          size: 20.0,
                        ),
                        onPressed: () =>
                            Helper.launchURL("tel:${widget.chat.chatStatus}"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        border: Border.all(
                          color: theme.cardColor,
                          width: 2,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: theme.primaryColor,
                          size: 20.0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: theme.cardColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 30),
                  itemBuilder: (context, index) => MessageBubble(
                    theme: theme,
                    message: _messages[index],
                    isMeSender: widget.chat.myId == _messages[index].senderId,
                  ),
                ),
              ),
              Container(
                color: theme.scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: EntryField(
                  fillColor: theme.scaffoldBackgroundColor,
                  isChat: true,
                  controller: _newMessageController,
                  hintText: AppLocalization.instance
                      .getLocalizationFor('writeSomething'),
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  restrictHeight: true,
                  suffix: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: theme.primaryColor,
                    ),
                    onPressed: () {
                      if (_newMessageController.text.trim().isEmpty) {
                        Toaster.showToastCenter(AppLocalization.instance
                            .getLocalizationFor("writeSomething"));
                      } else {
                        _chatCubit.initSendChatMessageText(
                            widget.chat, _newMessageController.text.trim());
                        _newMessageController.clear();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    try {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    } catch (e) {
      if (kDebugMode) {
        print("scrollToBottom: $e");
      }
    }
  }
}

class MessageBubble extends StatefulWidget {
  final ThemeData theme;
  final Message message;
  final bool isMeSender;

  const MessageBubble({
    super.key,
    required this.theme,
    required this.message,
    required this.isMeSender,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment:
            widget.isMeSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: widget.isMeSender
                      ? widget.theme.primaryColor
                      : widget.theme.scaffoldBackgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: widget.isMeSender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message.body ?? "",
                      style: widget.theme.textTheme.bodyLarge?.copyWith(
                        color: widget.isMeSender
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      textAlign:
                          widget.isMeSender ? TextAlign.end : TextAlign.start,
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.message.timeDiff ?? "",
                      style: widget.theme.textTheme.labelSmall?.copyWith(
                        color: widget.isMeSender
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
