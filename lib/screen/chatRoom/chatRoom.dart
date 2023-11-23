import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:do_it/selected.dart';
import 'package:do_it/created.dart';
import 'package:do_it/mediaQuery.dart';
import 'package:do_it/temp/tempClass.dart';
import 'package:do_it/screen/chatRoom/chatBubbles.dart';
import 'package:do_it/screen/chatRoom/MessageEditor.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    final _width = Provider.of<MediaQueryProvider>(context).getUseMenuWidth();
    final selectedProvider = Provider.of<SelectedProvider>(context);
    String selectedMenu = selectedProvider.getMenu();
    final chatList = Provider.of<CreatedProvider>(context).getChatList();
    List<ChatList> selectedChat =
        chatList.where((chat) => chat.name == selectedMenu).toList();
    ;

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
            child: Column(
              children: [
                ChatBubbles(
                    userId: "test",
                    userName: "test",
                    userImage: '../../../images/profile.png',
                    currentUser: true,
                    message: 'test',
                    sendTime: 'test',
                    today: true,
                    date: "2023.11.21",
                    read: "1"),
                ChatBubbles(
                    userId: "test",
                    userName: "test",
                    userImage: '../../../images/profile.png',
                    currentUser: false,
                    message: 'test',
                    sendTime: 'test',
                    today: true,
                    date: "2023.11.21",
                    read: "1"),
              ],
            ),
          ),
          MessageEditor(),
        ],
      ),
    );
  }
}
