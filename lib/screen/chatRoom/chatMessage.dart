import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:room505/temp/tempClass.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';

const platform = MethodChannel('screenshotChannel');

Future<void> takeScreenshot() async {
  try {
    final String result = await platform.invokeMethod('captureScreen');
    print('Screenshot captured at: $result');
  } on PlatformException catch (e) {
    print('Failed to capture screenshot: $e');
  }
}

class ChatMessage extends StatefulWidget {
  final TextEditingController textController;
  final FocusNode keyboardFocusNode;

  const ChatMessage({
    Key? key,
    required this.textController,
    required this.keyboardFocusNode,
  }) : super(key: key);

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  late IO.Socket socket;
  bool enabledSubmit = true;

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://localhost:3000');
    socket.connect();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void _openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        List<int> fileBytes = result.files.single.bytes ?? [];

        String fileName = result.files.single.name;
        String savePath = '${(await _localPath)!}/$fileName';

        File newFile = File(savePath);
        await newFile.writeAsBytes(fileBytes);

        setState(() {
          Provider.of<SelectedProvider>(context, listen: false)
              .selectedFile(newFile);
        });
      }
    } on PlatformException catch (e) {
      print("Unsupported operation: $e");
    }
  }

  Future<String?> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<CreatedProvider>(context).getUserInfo();
    String selectedSetMenu =
        Provider.of<SelectedProvider>(context).getSetMenu();
    int chatSeq = Provider.of<SelectedProvider>(context).getChat();
    Emoji emoji = Provider.of<SelectedProvider>(context).getEmoji();
    FocusScope.of(context).requestFocus(widget.keyboardFocusNode);

    if (emoji.emoji.isNotEmpty) {
      final currentText = widget.textController.text;
      final newEmoji = emoji.emoji;

      widget.textController.text = '$currentText$newEmoji';
      Provider.of<SelectedProvider>(context, listen: false)
          .selectedEmoji(const Emoji("", ""));
    }

    if (widget.textController.value.text.trim().isEmpty) {
      enabledSubmit = true;
    } else {
      enabledSubmit = false;
    }

    void sendMessage(String text) {
      final totalCount =
          Provider.of<CreatedProvider>(context, listen: false).getTotalCount();

      final message = Message(
        seq: user.seq,
        text: text,
        timestamp: DateTime.now(),
        userName: user.name,
        userImage: user.image,
      );

      socket.emit('sendMessage', [
        {
          'chatSeq': chatSeq,
          'message': message,
          'totalCount': totalCount,
        }
      ]);
      widget.textController.clear();
      Provider.of<SelectedProvider>(context, listen: false).setScroll(true);
    }

    if (widget.keyboardFocusNode.hasFocus) {
      widget.keyboardFocusNode.onKey = (node, event) {
        if (event is RawKeyEvent &&
            event.isKeyPressed(LogicalKeyboardKey.enter)) {
          if (event.isShiftPressed) {
            widget.textController.text += '\n';
          } else {
            if (!enabledSubmit) {
              sendMessage(widget.textController.text);
            }
          }
        }
        return KeyEventResult.ignored;
      };
    }

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
              child: TextField(
                controller: widget.textController,
                focusNode: widget.keyboardFocusNode,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                textInputAction: TextInputAction.go,
                // onChanged: (value) {
                //   if (value.endsWith('\n')) {
                //     widget.textController.value = TextEditingValue(
                //       text: value.substring(0, value.length - 1),
                //       selection:
                //           TextSelection.collapsed(offset: value.length - 1),
                //     );
                //   }
                // },
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
                          Icons.tag_faces,
                          size: 16,
                        ),
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        onPressed: () {
                          if (selectedSetMenu == "emoji") {
                            Provider.of<SelectedProvider>(context,
                                    listen: false)
                                .selectedSet("");
                          } else {
                            Provider.of<SelectedProvider>(context,
                                    listen: false)
                                .selectedSet("emoji");
                          }
                        },
                      ),
                    ),
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
                          Icons.file_upload,
                          size: 16,
                        ),
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        onPressed: _openFileExplorer,
                      ),
                    ),
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
                          Icons.fullscreen,
                          size: 16,
                        ),
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        onPressed: () {
                          takeScreenshot();
                        },
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
                      color: enabledSubmit
                          ? Theme.of(context).shadowColor
                          : Theme.of(context).textTheme.bodyText1!.color,
                      onPressed: () {
                        if (!enabledSubmit) {
                          sendMessage(widget.textController.text);
                        }
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
