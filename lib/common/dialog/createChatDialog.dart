import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:do_it/config/palette.dart';
import 'package:do_it/selected.dart';
import 'package:do_it/created.dart';
import 'package:do_it/common/dialog/userSelectDialog.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:do_it/temp/tempClass.dart';
import 'package:do_it/temp/randomNumber.dart';

class CreateChat extends StatefulWidget {
  const CreateChat({super.key});

  @override
  State<CreateChat> createState() => _CreateChatState();
}

class _CreateChatState extends State<CreateChat> {
  List<ChatList> chatList = [];
  List<ChatList> chatRoom = [];
  List<AddList> addList = [];

  bool emojiShowing = false;
  String emojiSelected = "";
  bool _buttonEnabled = false;
  String title = "";
  String errorMessage = "";
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatList =
        Provider.of<CreatedProvider>(context, listen: false).getChatList();
    addList =
        Provider.of<SelectedProvider>(context, listen: false).getAddList();

    String names = addList.map((item) => item.name).join(', ');
    bool isTitleContainedInSessionChats =
        chatList.any((chat) => names == chat.name);
    setState(() {
      title = names;
      textController.text = title;
      if (isTitleContainedInSessionChats) {
        _buttonEnabled = false;
        errorMessage = "이미 사용 중인 이름입니다.";
      } else {
        _buttonEnabled = true;
        errorMessage = "";
      }
    });
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
      bool isTitleEmpty = title.isEmpty;
      bool isChatListEmpty = chatList.isEmpty;
      bool isTitleContainedInSessionChats =
          chatList.any((chat) => value == chat.name);

      if (isTitleEmpty) {
        _buttonEnabled = false;
      } else if (!isTitleEmpty &&
          !isChatListEmpty &&
          isTitleContainedInSessionChats) {
        errorMessage = "이미 사용 중인 이름입니다.";
        _buttonEnabled = false;
      } else {
        errorMessage = "";
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

  void _createChat() async {
    final getSelectedMenu =
        Provider.of<SelectedProvider>(context, listen: false).getMenu();
    final seq = generateRandomNumber();
    int sotingNumber = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? chatsStringList = prefs.getStringList('chatList');

    if (chatsStringList != null) {
      sotingNumber = chatsStringList.length + 1;
      chatRoom = chatsStringList
          .map((chatRoomJson) => ChatList.fromJson(json.decode(chatRoomJson)))
          .toList();
    }

    ChatList newChatRoom =
        ChatList(seq, sotingNumber, title, emojiSelected, addList);
    chatRoom.add(newChatRoom);

    List<String> updatedChatRoomsStringList =
        chatRoom.map((chatRoom) => json.encode(chatRoom.toJson())).toList();
    prefs.setStringList('chatList', updatedChatRoomsStringList);

    List<String>? roomsStringList = prefs.getStringList('roomList');

    if (roomsStringList != null && getSelectedMenu != "") {
      for (String roomJson in roomsStringList) {
        Map<String, dynamic> roomMap = json.decode(roomJson);
        String name = roomMap['name'];

        if (name == getSelectedMenu) {
          List<int> chatSeqList = List<int>.from(roomMap['chatSeqList']);

          chatSeqList.add(seq);
          roomMap['chatSeqList'] = chatSeqList;
          roomsStringList[roomsStringList.indexOf(roomJson)] =
              json.encode(roomMap);
          prefs.setStringList('roomList', roomsStringList);
        }
      }
    }

    setState(() {
      Provider.of<SelectedProvider>(context, listen: false).resetAddList();
      Navigator.of(context).pop();
      Provider.of<CreatedProvider>(context, listen: false).loadRoomList();
      Provider.of<CreatedProvider>(context, listen: false).loadChatList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(
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
            SizedBox(
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
                  style: TextStyle(
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
