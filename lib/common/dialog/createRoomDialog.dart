import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:room505/config/palette.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:room505/temp/tempClass.dart';
import 'package:room505/temp/randomNumber.dart';

class CreateRoomDialog extends StatefulWidget {
  const CreateRoomDialog({super.key});

  @override
  State<CreateRoomDialog> createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  List<RoomList> roomList = [];
  List<RoomList> room = [];

  bool emojiShowing = false;
  String emojiSelected = "";
  bool _buttonEnabled = false;
  String title = "";
  String errorMessage = "";
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    roomList =
        Provider.of<CreatedProvider>(context, listen: false).getRoomList();
    Provider.of<SelectedProvider>(context, listen: false)
        .selectedPosition(0.0, 0.0);
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
      bool isChatListEmpty = roomList.isEmpty;
      bool isTitleContainedInSessionRooms =
          roomList.any((room) => value == room.name);
      print(isTitleContainedInSessionRooms);
      if (isTitleEmpty) {
        _buttonEnabled = false;
      } else if (!isTitleEmpty &&
          !isChatListEmpty &&
          isTitleContainedInSessionRooms) {
        errorMessage = "이미 사용 중인 이름입니다.";
        _buttonEnabled = false;
      } else {
        errorMessage = "";
        _buttonEnabled = true;
      }
    });
  }

  void _createRoom() async {
    int sotingNumber = 0;
    final seq = generateRandomNumber();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? roomsStringList = prefs.getStringList('roomList');

    if (roomsStringList != null) {
      sotingNumber = roomsStringList.length + 1;
      room = roomsStringList
          .map((roomJson) => RoomList.fromJson(json.decode(roomJson)))
          .toList();
    }

    RoomList newRoom = RoomList(sotingNumber, seq, title, emojiSelected, []);
    room.add(newRoom);

    List<String> updatedRoomsStringList =
        room.map((room) => json.encode(room.toJson())).toList();
    prefs.setStringList('roomList', updatedRoomsStringList);

    setState(() {
      Navigator.of(context).pop();
      Provider.of<CreatedProvider>(context, listen: false).loadRoomList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
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
                                _createRoom();
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
                          ? Icons.view_headline
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
                      labelText: "방 이름",
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
                      hintText: "방 이름을 입력해 주세요.",
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
