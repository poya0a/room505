import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:room505/common/dialog/emojiDialog.dart';
import 'package:room505/common/dialog/fileDialog.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';
import 'package:room505/mediaQuery.dart';
import 'package:room505/temp/tempClass.dart';
import 'package:room505/screen/chatRoom/chatBubbles.dart';
import 'package:room505/screen/chatRoom/chatMessage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late IO.Socket socket;
  late ScrollController _scrollController;
  late TextEditingController _textController;
  late FocusNode _keyboardFocusNode;
  int chatSeq = 0;
  List<Message> chatMessages = [];
  late bool scrollToBottom;

  void getMessages() {
    socket = IO.io('http://localhost:3000');
    socket.connect();

    socket.on('message_' + chatSeq.toString(), (data) {
      if (data.isNotEmpty) {
        if (data['message'] != null && data['message'].isNotEmpty) {
          List<dynamic> messagesData = data['message'];

          List<Message> messages =
              messagesData.map((json) => Message.fromJson(json)).toList();

          setState(() {
            for (int i = 1; i < messages.length; i++) {
              final currentTime = messages[i].timestamp;
              final previousMessageTime = messages[i - 1].timestamp;

              if (previousMessageTime.hour == currentTime.hour &&
                  previousMessageTime.minute == currentTime.minute) {
                messages[i - 1].timeCheck = false;
              }
            }
            chatMessages = messages;
            scrollEvent();
          });
        }
      } else {
        chatMessages = [];
      }
    });
  }

  void scrollEvent() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (scrollToBottom) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textController = TextEditingController();
    _keyboardFocusNode = FocusNode();
    chatSeq = Provider.of<SelectedProvider>(context, listen: false).getChat();
    scrollToBottom =
        Provider.of<SelectedProvider>(context, listen: false).getScroll();
    getMessages();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<SelectedProvider>(context, listen: false).setScroll(true);
      } else {
        Provider.of<SelectedProvider>(context, listen: false).setScroll(false);
      }
    });
    Provider.of<SelectedProvider>(context, listen: false)
        .addListener(_handleChatSeqChange);
  }

  void _handleChatSeqChange() {
    final newChatSeq =
        Provider.of<SelectedProvider>(context, listen: false).getChat();
    if (newChatSeq != chatSeq) {
      chatSeq = newChatSeq;
      getMessages();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _menuWidth =
        Provider.of<MediaQueryProvider>(context).getUserMenuWidth();
    final _profileWidth =
        Provider.of<MediaQueryProvider>(context).getUserMenuWidth();
    final selectedProvider = Provider.of<SelectedProvider>(context);
    String selectedSetMenu = selectedProvider.getSetMenu();
    File selectedFile = selectedProvider.getFile();
    final chatList = Provider.of<CreatedProvider>(context).getChatList();
    ChatList? selectedChat = chatList.firstWhere((chat) => chat.seq == chatSeq,
        orElse: () => ChatList(0, "", "", []));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        Provider.of<SelectedProvider>(context, listen: false).setScroll(false);
        Provider.of<CreatedProvider>(context, listen: false)
            .loadChats(chatSeq, chatMessages.length);
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width - _menuWidth - _profileWidth,
      color: Theme.of(context).dialogBackgroundColor,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).shadowColor,
                      width: 1,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_menuWidth == 0)
                        IconButton(
                          icon: const Icon(Icons.featured_play_list),
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          onPressed: () {
                            Provider.of<MediaQueryProvider>(context,
                                    listen: false)
                                .controlUserMenuWidth(250);
                          },
                        ),
                      if (_menuWidth != 0) Container(),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              selectedChat.seq != 0
                                  ? selectedChat.emoji == ""
                                      ? Icons.chat_bubble
                                      : IconData(
                                          int.parse(selectedChat.emoji,
                                              radix: 16),
                                          fontFamily: 'EmojiFontFamily')
                                  : Icons.chat_bubble,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              selectedChat.seq != 0 ? selectedChat.name : '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search),
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: chatMessages.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isDifferentDate = true;

                      bool areDatesDifferent(
                          DateTime dateTime1, DateTime dateTime2) {
                        if (dateTime1.year != dateTime2.year ||
                            dateTime1.month != dateTime2.month ||
                            dateTime1.day != dateTime2.day) {
                          return true;
                        } else {
                          return false;
                        }
                      }

                      if (index > 0) {
                        isDifferentDate = areDatesDifferent(
                          chatMessages[index - 1].timestamp,
                          chatMessages[index].timestamp,
                        );
                      }
                      return ChatBubbles(
                        userSeq: chatMessages[index].seq,
                        userName: chatMessages[index].userName,
                        userImage: chatMessages[index].userImage,
                        message: chatMessages[index].text,
                        dateTime: chatMessages[index].timestamp,
                        dateCheck: isDifferentDate,
                        timeCheck: chatMessages[index].timeCheck,
                        read: "1",
                      );
                    },
                  ),
                ),
              ),
              ChatMessage(
                textController: _textController,
                keyboardFocusNode: _keyboardFocusNode,
              ),
              // MessageEditor(),
            ],
          ),
          if (selectedSetMenu == "emoji") const EmojiDiaolg(),
          if (selectedFile.path != "") const FileDiallog(),
        ],
      ),
    );
  }
}
