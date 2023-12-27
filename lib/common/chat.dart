import 'package:flutter/material.dart';
import 'dart:core';
import 'package:provider/provider.dart';
import 'package:room505/auth.dart';
import 'package:room505/chat.dart';
import 'package:room505/selected.dart';

class Chat extends StatefulWidget {
  final String roomKey;
  final String name;
  final String emoji;
  final String lastMsg;
  final int time;

  Chat({
    required this.roomKey,
    required this.name,
    required this.emoji,
    required this.lastMsg,
    required this.time,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GlobalKey _globalKey = GlobalKey();
  Map<String, String> user = {};
  String lastDate = "";

  void convertUnixTimeToFormattedDate() {
    DateTime now = DateTime.now();
    var dateTime = DateTime.fromMillisecondsSinceEpoch(widget.time * 1000);

    if (now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day) {
      String ampm;

      if (dateTime.hour < 12) {
        ampm = '오전';
      } else {
        ampm = '오후';
      }

      lastDate = '${ampm} ${dateTime.hour}:${dateTime.minute}';
    } else {
      lastDate =
          '${dateTime.month.toString().padLeft(2, '0')}월 ${dateTime.day.toString().padLeft(2, '0')}일';
    }
  }

  void initState() {
    super.initState();
    user = Provider.of<AuthProvider>(context, listen: false).getUser();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProvider =
        Provider.of<SelectedProvider>(context, listen: false);
    String selectedChat =
        Provider.of<ChatProvider>(context).getChatRoom().roomKey;

    return GestureDetector(
      onTap: () {
        Provider.of<ChatProvider>(context, listen: false)
            .loadChats(user, widget.roomKey);
        selectedProvider.selectedMenu("chat");
      },
      onDoubleTap: () {
        final RenderBox? box =
            _globalKey.currentContext?.findRenderObject() as RenderBox?;
        final position = box?.localToGlobal(Offset.zero);
        if (position != null) {
          selectedProvider.selectedPosition(position.dy, position.dx);
          selectedProvider.selectedSet("chat");
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: selectedChat == widget.roomKey
              ? Theme.of(context).dialogBackgroundColor
              : Theme.of(context).canvasColor,
        ),
        child: Row(
          children: [
            Icon(
              widget.emoji != ""
                  ? IconData(int.parse(widget.emoji, radix: 16),
                      fontFamily: 'EmojiFontFamily')
                  : Icons.chat_bubble,
              color: selectedChat == widget.roomKey
                  ? Theme.of(context).textTheme.headline1!.color
                  : Theme.of(context).textTheme.bodyText1!.color,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              key: _globalKey,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: selectedChat == widget.roomKey
                            ? Theme.of(context).textTheme.headline1!.color
                            : Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      lastDate,
                      maxLines: 1,
                      style: TextStyle(
                        color: selectedChat == widget.roomKey
                            ? Theme.of(context).textTheme.headline1!.color
                            : Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.lastMsg,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: selectedChat == widget.roomKey
                        ? Theme.of(context).textTheme.headline1!.color
                        : Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
