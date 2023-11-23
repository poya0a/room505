import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:do_it/selected.dart';

class Room extends StatefulWidget {
  final String keyValue;
  final String name;
  final String emoji;

  const Room({
    required this.keyValue,
    required this.name,
    required this.emoji,
  });

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  bool iconHovered = false;
  bool menuHovered = false;

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final selectedProvider = Provider.of<SelectedProvider>(context);
    String selectedMenu = selectedProvider.getMenu();

    return Stack(
      children: [
        Row(
          children: [
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  iconHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  iconHovered = false;
                });
              },
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (selectedMenu == widget.keyValue) {
                      selectedProvider.selectedMenu("");
                    } else {
                      selectedProvider.selectedMenu(widget.keyValue);
                    }
                  });
                },
                icon: Icon(
                  widget.emoji == ""
                      ? Icons.view_headline
                      : IconData(int.parse(widget.emoji, radix: 16),
                          fontFamily: 'EmojiFontFamily'),
                ),
                color: selectedMenu == widget.keyValue
                    ? Theme.of(context).textTheme.headline1!.color
                    : Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            Expanded(
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    menuHovered = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    menuHovered = false;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    final RenderBox? box = _globalKey.currentContext
                        ?.findRenderObject() as RenderBox?;
                    final position = box?.localToGlobal(Offset.zero);
                    if (position != null) {
                      selectedProvider.selectedPosition(
                          position.dy, position.dx);
                      selectedProvider.selectedMenu(widget.keyValue);
                    }
                  },
                  child: Text(
                    widget.name,
                    key: _globalKey,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: selectedMenu == widget.keyValue
                          ? Theme.of(context).textTheme.headline1!.color
                          : Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
