import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:do_it/theme.dart';
import 'package:do_it/selected.dart';
import 'package:do_it/created.dart';
import 'package:do_it/temp/tempClass.dart';
import 'package:do_it/common/menu.dart';
import 'package:do_it/common/chat.dart';
import 'package:do_it/common/room.dart';
import 'package:do_it/common/dialog/userSelectDialog.dart';

class UserMenu extends StatefulWidget {
  const UserMenu({super.key});

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  String mode = "라이트 모드";
  List<RoomList> initRoom = [];
  List<ChatList> initChat = [];

  void _showUserList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserSelectDialog();
      },
    );
  }

  Future<void> saveLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> roomListJson =
        initRoom.map((room) => jsonEncode(room.toJson())).toList();
    await prefs.setStringList('roomList', roomListJson);

    List<String> chatListJson =
        initChat.map((chat) => jsonEncode(chat.toJson())).toList();
    await prefs.setStringList('chatList', chatListJson);
  }

  @override
  void initState() {
    super.initState();

    initRoom.add(
      RoomList(0, "ROOM505", "ROOM505", "", [0]),
    );
    initChat.add(
      ChatList(0, 001, "CHAT", "", []),
    );

    saveLists();

    setState(() {
      Provider.of<CreatedProvider>(context, listen: false).loadRoomList();
      Provider.of<CreatedProvider>(context, listen: false).loadChatList();
    });
  }

  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final selectedProvider = Provider.of<SelectedProvider>(context);
    String selectedMenu = selectedProvider.getMenu();

    final roomList = Provider.of<CreatedProvider>(context).getRoomList();
    final chatList = Provider.of<CreatedProvider>(context).getChatList();

    return Container(
      color: Theme.of(context).canvasColor,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                children: [
                  // 워크스페이스
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).shadowColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "CHAT",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -5,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.send),
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                onPressed: () {
                                  _showUserList(context);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 도구
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).shadowColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 140,
                        child: const Column(
                          children: [
                            Menu(
                              icon: Icons.edit_document,
                              keyValue: "document",
                              text: "문서",
                            ),
                            Menu(
                              icon: Icons.filter_none,
                              keyValue: "file",
                              text: "파일",
                            ),
                            Menu(
                              icon: Icons.work,
                              keyValue: "connect",
                              text: "Do Connect",
                            ),
                            Menu(
                              icon: Icons.more_horiz,
                              keyValue: "more",
                              text: "더보기",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 채팅룸
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: roomList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final room = roomList[index];

                          List<Widget> roomWidgets = [
                            Room(
                              keyValue: room.keyValue,
                              name: room.name,
                              emoji: room.emoji,
                            ),
                          ];

                          if (selectedMenu == room.keyValue ||
                              chatList
                                  .any((chat) => chat.name == selectedMenu)) {
                            for (var seq in room.chatSeqList) {
                              var correspondingChat = chatList.firstWhere(
                                (chat) => chat.seq == seq,
                                orElse: () => ChatList(0, 001, "CHAT", "", []),
                              );

                              if (selectedMenu == room.keyValue ||
                                  selectedMenu == correspondingChat.name) {
                                Widget chatWidget = Chat(
                                  keyValue: correspondingChat.name,
                                  name: correspondingChat.name,
                                  emoji: correspondingChat.emoji,
                                  inRoom: true,
                                );
                                roomWidgets.add(chatWidget);
                              }
                            }
                          }

                          for (var chat in chatList) {
                            if (!room.chatSeqList.contains(chat.seq)) {
                              roomWidgets.add(
                                Chat(
                                  keyValue: chat.name,
                                  name: chat.name,
                                  emoji: chat.emoji,
                                  inRoom: false,
                                ),
                              );
                            }
                          }

                          return Column(
                            children: roomWidgets,
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // 모드 스위치
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).shadowColor,
                    width: 3,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Stack(
                  children: [
                    Positioned(
                      child: Row(
                        children: [
                          Switch(
                            value: themeProvider.currentTheme == darkTheme,
                            onChanged: (value) {
                              themeProvider.toggleTheme();
                              setState(() {
                                if (value) {
                                  mode = "다크 모드";
                                } else {
                                  mode = "라이트 모드";
                                }
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(mode),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.videocam),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
