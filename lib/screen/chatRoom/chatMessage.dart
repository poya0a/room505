import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:room505/auth.dart';
import 'package:room505/chat.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:room505/socket.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';
import 'package:room505/auth/authClass.dart';
import 'package:room505/screen/chatRoom/chatClass.dart';

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
  const ChatMessage({Key? key}) : super(key: key);

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _keyboardFocusNode = FocusNode();
  bool keyboardFocus = true;
  bool enabledSubmit = true;

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
  void initState() {
    super.initState();
    _textController.addListener(_textChangeListener);
  }

  void _textChangeListener() {
    setState(() {
      if (_textController.text != "") {
        enabledSubmit = false;
      } else {
        enabledSubmit = true;
      }
    });
  }

  @override
  void dispose() {
    _textController.removeListener(_textChangeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<AuthProvider>(context).getUserInfo();
    String roomKey = Provider.of<ChatProvider>(context).getChatRoom().roomKey;
    String selectedSetMenu =
        Provider.of<SelectedProvider>(context).getSetMenu();
    Emoji emoji = Provider.of<SelectedProvider>(context).getEmoji();

    if (emoji.emoji.isNotEmpty) {
      final currentText = _textController.text;
      final newEmoji = emoji.emoji;

      _textController.text = '$currentText$newEmoji';
      Provider.of<SelectedProvider>(context, listen: false)
          .selectedEmoji(const Emoji("", ""));
    }

    if (keyboardFocus == true) {
      FocusScope.of(context).requestFocus(_keyboardFocusNode);
      keyboardFocus = false;
    }

    void sendMessage(String text) {
      String newUuid = Uuid().v4();
      Message sendMsg = Message('101', roomKey, newUuid, newUuid, user.uid,
          user.userName, text, text, 'WEB');
      Provider.of<SocketProvider>(context, listen: false).sendMessage(sendMsg);

      Provider.of<SelectedProvider>(context, listen: false).setScroll(true);
    }

    if (_keyboardFocusNode.hasFocus) {
      _keyboardFocusNode.onKey = (node, event) {
        if (event is RawKeyEvent &&
            event.isKeyPressed(LogicalKeyboardKey.enter)) {
          if (event.isShiftPressed) {
            _textController.text += '\n';
          } else {
            if (!enabledSubmit) {
              sendMessage(_textController.text);
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
                controller: _textController,
                focusNode: _keyboardFocusNode,
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
                          sendMessage(_textController.text);
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
