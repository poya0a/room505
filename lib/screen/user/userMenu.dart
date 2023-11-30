import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:room505/theme.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';
import 'package:room505/temp/tempClass.dart';
import 'package:room505/common/menu.dart';
import 'package:room505/common/chat.dart';
import 'package:room505/common/room.dart';
import 'package:room505/common/dialog/userSelectDialog.dart';

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
      RoomList(0, 001, "ROOM505", "", [0]),
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
                                icon: Icon(Icons.add),
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                onPressed: () {
                                  Provider.of<SelectedProvider>(context,
                                          listen: false)
                                      .selectedRoom(0);
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
                    padding: const EdgeInsets.all(10),
                    // width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: roomList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final room = roomList[index];
                            final selectedMenu =
                                Provider.of<SelectedProvider>(context)
                                    .getMenu();
                            List<ChatList> selectedChat =
                                chatList.where((chat) {
                              return room.chatSeqList.contains(chat.seq) &&
                                  chat.name == selectedMenu;
                            }).toList();

                            List<ChatList> includedChats =
                                chatList.where((chat) {
                              return room.chatSeqList.contains(chat.seq);
                            }).toList();

                            bool showChatList = selectedMenu == room.name ||
                                selectedChat.isNotEmpty;

                            return Column(
                              children: [
                                Room(
                                  seq: room.seq,
                                  name: room.name,
                                  emoji: room.emoji,
                                ),
                                if (showChatList)
                                  Column(
                                    children: includedChats.map((chat) {
                                      return Chat(
                                        seq: chat.seq,
                                        name: chat.name,
                                        emoji: chat.emoji,
                                        inRoom: true,
                                      );
                                    }).toList(),
                                  ),
                              ],
                            );
                          },
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: chatList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final chat = chatList[index];
                            bool isNotIncludedInAnyRoom = !roomList.any(
                                (room) => room.chatSeqList.contains(chat.seq));

                            if (isNotIncludedInAnyRoom) {
                              return Column(
                                children: [
                                  Chat(
                                    seq: chat.seq,
                                    name: chat.name,
                                    emoji: chat.emoji,
                                    inRoom: false,
                                  ),
                                  // Column(children: includedChatWidgets),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
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
