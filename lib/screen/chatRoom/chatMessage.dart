import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:room505/created.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_keyboardFocusNode);
    });
  }

  void sendMessage(String message) {
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
            color: Theme.of(context).shadowColor,
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: RawKeyboardListener(
                focusNode: _keyboardFocusNode,
                onKey: (event) {
                  if (event is RawKeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.enter &&
                      !event.isShiftPressed) {
                    sendMessage(_textEditingController.text);
                  }
                },
                child: TextField(
                  controller: _textEditingController,
                  minLines: 1,
                  maxLines: 5,
                  // textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.transparent,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.text_fields,
                          size: 16,
                        ),
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: Colors.transparent,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        size: 16,
                      ),
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      onPressed: () {
                        sendMessage(_textEditingController.text);
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
