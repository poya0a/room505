import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';
import 'package:room505/mediaQuery.dart';
import 'package:room505/temp/tempClass.dart';
import 'package:room505/screen/chatRoom/chatBubbles.dart';
import 'package:room505/screen/chatRoom/MessageEditor.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Provider.of<CreatedProvider>(context, listen: false).loadChat();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _width = Provider.of<MediaQueryProvider>(context).getUseMenuWidth();
    final selectedProvider = Provider.of<SelectedProvider>(context);
    String selectedMenu = selectedProvider.getMenu();
    final chatList = Provider.of<CreatedProvider>(context).getChatList();
    final chat = Provider.of<CreatedProvider>(context).getChat();
    List<ChatList> selectedChat =
        chatList.where((chat) => chat.name == selectedMenu).toList();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width - _width,
      color: Theme.of(context).dialogBackgroundColor,
      constraints: const BoxConstraints(
        minWidth: 280,
        minHeight: 650,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).shadowColor,
                  width: 1,
                ),
                top: BorderSide(
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
                  if (_width == 0)
                    IconButton(
                      icon: Icon(Icons.featured_play_list),
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      onPressed: () {
                        Provider.of<MediaQueryProvider>(context, listen: false)
                            .controlUseMenuWidth(250);
                      },
                    ),
                  if (_width != 0) Container(),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          selectedChat.isNotEmpty
                              ? selectedChat[0].emoji == ""
                                  ? Icons.chat_bubble
                                  : IconData(
                                      int.parse(selectedChat[0].emoji,
                                          radix: 16),
                                      fontFamily: 'EmojiFontFamily')
                              : Icons.chat_bubble,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          selectedChat.isNotEmpty ? selectedChat[0].name : '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.search),
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.more_horiz),
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
                itemCount: chat.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChatBubbles(
                    userId: "test",
                    userName: "test",
                    userImage: '../../../images/profile.png',
                    currentUser: true,
                    message: chat[index],
                    sendTime: '오후 5:00',
                    today: true,
                    date: "2023.11.21",
                    read: "1",
                  );
                },
              ),
            ),
          ),
          MessageEditor(),
        ],
      ),
    );
  }
}
