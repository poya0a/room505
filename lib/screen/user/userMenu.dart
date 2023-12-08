import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room505/created.dart';
import 'package:room505/theme.dart';
import 'package:room505/temp/tempClass.dart';
import 'package:room505/common/menu.dart';
import 'package:room505/common/chat.dart';
import 'package:room505/common/dialog/userSelectDialog.dart';

class UserMenu extends StatefulWidget {
  const UserMenu({super.key});

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  String mode = "라이트 모드";
  List<ChatList> chatRooms = [];

  void _showUserList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const UserSelectDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final createdProvider = Provider.of<CreatedProvider>(context);
    createdProvider.loadChatList();
    chatRooms = createdProvider.getChatList();

    return Container(
      color: Theme.of(context).canvasColor,
      child: Stack(
        children: [
          Padding(
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
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
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
                  height: 160,
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
                  height: MediaQuery.of(context).size.height - 327,
                  padding: const EdgeInsets.all(10),
                  child: chatRooms.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: chatRooms.length,
                          itemBuilder: (BuildContext context, int index) {
                            final chat = chatRooms[index];
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Chat(
                                    seq: chat.seq,
                                    name: chat.name,
                                    emoji: chat.emoji,
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      : const Center(
                          child: Text("대화를 시작하세요!"),
                        ),
                ),
              ],
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
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                          const SizedBox(
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
                        icon: const Icon(Icons.videocam),
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
