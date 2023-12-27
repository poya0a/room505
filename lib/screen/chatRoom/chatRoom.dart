import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:room505/auth.dart';
import 'package:room505/chat.dart';
import 'package:room505/common/dialog/emojiDialog.dart';
import 'package:room505/common/dialog/fileDialog.dart';
import 'package:room505/selected.dart';
import 'package:room505/mediaQuery.dart';
import 'package:room505/screen/chatRoom/chatClass.dart';
import 'package:room505/screen/chatRoom/chatBubbles.dart';
import 'package:room505/screen/chatRoom/chatMessage.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late ScrollController _scrollController;

  String roomKey = "";
  List<Chats> chatMessages = [];
  late bool scrollToBottom;

  void getMessages() {
    List<Chats> dataMessages =
        Provider.of<ChatProvider>(context, listen: false).getChats();

    if (dataMessages.isNotEmpty) {
      for (int i = 1; i < dataMessages.length; i++) {
        final currentTime = dataMessages[i].writeDate;
        final previousMessageTime = dataMessages[i - 1].writeDate;

        if (previousMessageTime.hour == currentTime.hour &&
            previousMessageTime.minute == currentTime.minute) {
          dataMessages[i - 1].timeCheck = false;
        }
      }

      setState(() {
        chatMessages.addAll(dataMessages);
        scrollEvent();
      });
    } else {
      chatMessages = [];
    }
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
    roomKey =
        Provider.of<ChatProvider>(context, listen: false).getChatRoom().roomKey;
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
    final newRoomKey =
        Provider.of<ChatProvider>(context, listen: false).getChatRoom().roomKey;
    if (newRoomKey != roomKey) {
      roomKey = newRoomKey;
      getMessages();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _menuWidth =
        Provider.of<MediaQueryProvider>(context).getUserMenuWidth();
    final _profileWidth =
        Provider.of<MediaQueryProvider>(context).getUserMenuWidth();
    final selectedProvider = Provider.of<SelectedProvider>(context);
    final userUid = Provider.of<AuthProvider>(context).getUser()['uid'];
    String selectedSetMenu = selectedProvider.getSetMenu();
    File selectedFile = selectedProvider.getFile();
    Member selectedChat = Provider.of<ChatProvider>(context)
        .getChatRoom()
        .member
        .firstWhere((user) => user.uid == userUid,
            orElse: () => Member("", "", "", "", "", "", 0, "", 0));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        Provider.of<SelectedProvider>(context, listen: false).setScroll(false);
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
                              selectedChat.roomEmoji != ""
                                  ? IconData(
                                      int.parse(selectedChat.roomEmoji,
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
                              selectedChat.roomName,
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
                          chatMessages[index - 1].writeDate,
                          chatMessages[index].writeDate,
                        );
                      }
                      return ChatBubbles(
                        userUid: chatMessages[index].uid,
                        userName: chatMessages[index].userName,
                        message: chatMessages[index].msg,
                        dateTime: chatMessages[index].writeDate,
                        dateCheck: isDifferentDate,
                        timeCheck: chatMessages[index].timeCheck,
                        read: "1",
                      );
                    },
                  ),
                ),
              ),
              ChatMessage(),
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
