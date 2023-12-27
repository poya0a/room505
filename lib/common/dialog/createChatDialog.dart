import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:room505/auth.dart';
import 'package:room505/chat.dart';
import 'package:room505/config/palette.dart';
import 'package:room505/selected.dart';
import 'package:room505/common/dialog/userSelectDialog.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:room505/auth/authClass.dart';
import 'package:room505/config/conf.dart';

class CreateChat extends StatefulWidget {
  const CreateChat({super.key});

  @override
  State<CreateChat> createState() => _CreateChatState();
}

class _CreateChatState extends State<CreateChat> {
  User userInfo = User('', '', '', '', '', '', '', '', [], false, '', '', '',
      [], '', '', 0, '', [], 0, 0, [], "", "");
  List<AddList> addList = [];

  bool emojiShowing = false;
  String emojiSelected = "";
  bool _buttonEnabled = false;
  String defaultTitle = "";
  String title = "";
  String errorMessage = "";
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userInfo = Provider.of<AuthProvider>(context, listen: false).getUserInfo();
    addList =
        Provider.of<SelectedProvider>(context, listen: false).getAddList();
    defaultTitle = addList.length > 1
        ? addList
            .where((item) => item.uid != userInfo.uid)
            .map((item) => item.name)
            .join(', ')
        : addList.map((item) => item.name).join(', ');
    textController.text = defaultTitle;

    _buttonEnabled = true;
  }

  void _onEmojiSelected(Emoji emoji) {
    Runes runes = emoji.toString().runes;
    int codePoint = runes.elementAt(7);
    String emojiInHex = codePoint.toRadixString(16);
    setState(() {
      emojiSelected = emojiInHex;
      emojiShowing = false;
    });
  }

  void _onTextFieldChanged(String value) {
    setState(() {
      title = value;
      if (title.isEmpty) {
        _buttonEnabled = false;
      } else {
        _buttonEnabled = true;
      }
    });
  }

  void _previousStep(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserSelectDialog();
      },
    );
  }

  Future<void> _createChat() async {
    final String url = requests("ROOM_MAKE");
    final user = Provider.of<AuthProvider>(context, listen: false).getUser();
    List<String> uidList = addList.map((item) => item.uid).toList();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'devicekey': user['devicekey'],
          'uid': user['uid'],
          'uids': uidList,
          'title': defaultTitle == title || textController.text == defaultTitle
              ? ""
              : title,
          'emoji': emojiSelected,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final resultValue = responseData['result'];
        if (resultValue == "success") {
          final resultRoomKey = responseData['data']['roomkey'];
          setState(() {
            final selectedProvider =
                Provider.of<SelectedProvider>(context, listen: false);
            final chatProvider =
                Provider.of<ChatProvider>(context, listen: false);
            chatProvider.loadChatList(user);
            chatProvider.loadChats(user, resultRoomKey);
            selectedProvider.resetAddList();
            selectedProvider.selectedMenu("chat");
            Navigator.of(context).pop();
          });
        } else {
          setState(() {
            errorMessage = '잘못된 형식의 응답입니다.';
          });
        }
      } else {
        setState(() {
          errorMessage = '서버로부터 올바른 응답을 받지 못했습니다.';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = '네트워크 오류가 발생하였습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _previousStep(context);
                    },
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: _buttonEnabled
                            ? Theme.of(context).canvasColor
                            : Colors.grey,
                      ),
                      child: TextButton(
                        onPressed: _buttonEnabled
                            ? () {
                                _createChat();
                              }
                            : null,
                        child: Text(
                          "생성",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        emojiShowing = !emojiShowing;
                      });
                    },
                    icon: Icon(
                      emojiSelected == ""
                          ? Icons.chat_bubble
                          : IconData(int.parse(emojiSelected, radix: 16),
                              fontFamily: 'EmojiFontFamily'),
                      color: Theme.of(context).textTheme.bodyText2!.color,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    inputFormatters: [LengthLimitingTextInputFormatter(80)],
                    decoration: const InputDecoration(
                      labelText: "채팅 방 이름",
                      labelStyle:
                          TextStyle(fontSize: 12, color: Palette.subColor),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Palette.subColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Palette.mainColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      hintText: "채팅 방 이름을 입력해 주세요.",
                      hintStyle:
                          TextStyle(fontSize: 12, color: Palette.subColor),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    style: const TextStyle(
                      color: Palette.subColor,
                    ),
                    onChanged: (value) {
                      _onTextFieldChanged(value);
                    },
                  ),
                ),
              ],
            ),
            if (errorMessage != "")
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Palette.subColor,
                    fontSize: 12,
                  ),
                ),
              ),
            if (emojiShowing)
              Expanded(
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      _onEmojiSelected(emoji);
                    },
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 *
                          (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                              ? 1.30
                              : 1.0),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: Theme.of(context).backgroundColor,
                      indicatorColor: Palette.mainColor,
                      iconColorSelected: Palette.mainColor,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Palette.mainColor,
                      enableSkinTones: true,
                      recentTabBehavior: RecentTabBehavior.RECENT,
                      recentsLimit: 28,
                      replaceEmojiOnLimitExceed: false,
                      noRecents: const Text(
                        'No Recents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ),
                      loadingIndicator: const SizedBox.shrink(),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                      checkPlatformCompatibility: true,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
