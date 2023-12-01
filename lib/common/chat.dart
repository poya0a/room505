import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';

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
    String selectedMenu = Provider.of<SelectedProvider>(context).getMenu();

    return GestureDetector(
      onTap: () {
        final RenderBox? box =
            _globalKey.currentContext?.findRenderObject() as RenderBox?;
        final position = box?.localToGlobal(Offset.zero);
        if (position != null) {
          selectedProvider.selectedPosition(position.dy, position.dx);
          selectedProvider.selectedMenu(widget.name);
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                key: _globalKey,
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
