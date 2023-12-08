import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:room505/created.dart';

class MessageEditor extends StatefulWidget {
  const MessageEditor({super.key});

  @override
  State<MessageEditor> createState() => _MessageEditorState();
}

class _MessageEditorState extends State<MessageEditor> {
  final QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _keyboardFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool toolVisibility = true;
  bool isScrollable = false;
  double textFieldHeight = 38.0;

  void sendMessage() async {
    final chatText = _controller.document.toPlainText();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chat = prefs.getStringList('chat') ?? [];
    chat.add(chatText);
    await prefs.setStringList('chat', chat);
    _controller.clear();

    setState(() {
      // Provider.of<CreatedProvider>(context, listen: false).loadChat();
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.document.toPlainText();
      final lineCount = text.split('\n').length - 1;
      final calculatedHeight = lineCount * 38.0;
      setState(() {
        textFieldHeight = calculatedHeight <= 190 ? calculatedHeight : 190;
        isScrollable = lineCount > 5;
      });

      // if (lineCount > 1 && text.endsWith('\n')) {
      //   sendMessage();
      // }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
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
        child: QuillProvider(
          configurations: QuillConfigurations(
            controller: _controller,
            sharedConfigurations: const QuillSharedConfigurations(
              locale: Locale('ko'),
            ),
          ),
          child: Column(
            children: [
              if (toolVisibility)
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(5)),
                  ),
                  child: const QuillToolbar(),
                ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                constraints:
                    const BoxConstraints(minHeight: 38.0, maxHeight: 190.0),
                child: RawKeyboardListener(
                  focusNode: _keyboardFocusNode,
                  onKey: (event) {
                    if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.enter &&
                        !event.isShiftPressed) {
                      sendMessage();
                    }
                  },
                  child: NotificationListener<SizeChangedLayoutNotification>(
                    onNotification: (notification) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      });
                      return true;
                    },
                    child: QuillEditor.basic(
                      scrollController: _scrollController,
                      focusNode: _focusNode,
                      configurations: const QuillEditorConfigurations(
                        readOnly: false,
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
                          onPressed: () {
                            setState(() {
                              toolVisibility = !toolVisibility;
                            });
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
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        onPressed: () {
                          sendMessage();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
