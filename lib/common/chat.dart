import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:do_it/selected.dart';

class Chat extends StatefulWidget {
  final String keyValue;
  final String name;
  final String emoji;
  final bool inRoom;

  const Chat({
    required this.keyValue,
    required this.name,
    required this.emoji,
    required this.inRoom,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    final selectedProvider = Provider.of<SelectedProvider>(context);
    String selectedMenu = selectedProvider.getMenu();

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProvider.selectedMenu(widget.name);
        });
      },
      child: Container(
        padding: widget.inRoom
            ? EdgeInsets.fromLTRB(40, 5, 10, 5)
            : EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: selectedMenu == widget.name
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
              color: selectedMenu == widget.name
                  ? Theme.of(context).textTheme.headline1!.color
                  : Theme.of(context).textTheme.bodyText1!.color,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                widget.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: selectedMenu == widget.name
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
