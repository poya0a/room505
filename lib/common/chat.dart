import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';

class Chat extends StatefulWidget {
  final int seq;
  final String name;
  final String emoji;

  Chat({
    required this.seq,
    required this.name,
    required this.emoji,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final selectedProvider =
        Provider.of<SelectedProvider>(context, listen: false);
    int selectedChat = Provider.of<SelectedProvider>(context).getChat();

    return GestureDetector(
      onTap: () {
        Provider.of<CreatedProvider>(context, listen: false)
            .loadChats(widget.seq, 0);
        selectedProvider.selectedMenu("chat");
        selectedProvider.selectedChat(widget.seq);
      },
      onDoubleTap: () {
        final RenderBox? box =
            _globalKey.currentContext?.findRenderObject() as RenderBox?;
        final position = box?.localToGlobal(Offset.zero);
        if (position != null) {
          selectedProvider.selectedPosition(position.dy, position.dx);
          selectedProvider.selectedSet("chat");
          selectedProvider.selectedChat(widget.seq);
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: selectedChat == widget.seq
              ? Theme.of(context).dialogBackgroundColor
              : Theme.of(context).canvasColor,
        ),
        child: Row(
          children: [
            Icon(
              widget.emoji == ""
                  ? Icons.chat_bubble
                  : IconData(int.parse(widget.emoji, radix: 16),
                      fontFamily: 'EmojiFontFamily'),
              color: selectedChat == widget.seq
                  ? Theme.of(context).textTheme.headline1!.color
                  : Theme.of(context).textTheme.bodyText1!.color,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                widget.name,
                key: _globalKey,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: selectedChat == widget.seq
                      ? Theme.of(context).textTheme.headline1!.color
                      : Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
