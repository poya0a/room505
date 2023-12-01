import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:room505/config/palette.dart';
import 'package:room505/temp/tempClass.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChangeStatusDialog extends StatefulWidget {
  const ChangeStatusDialog({super.key});

  @override
  State<ChangeStatusDialog> createState() => _ChangeStatusDialogState();
}

class _ChangeStatusDialogState extends State<ChangeStatusDialog> {
  bool emojiShowing = false;
  String emojiSelected = "";
  String statusString = "";
  bool _buttonEnabled = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _onEmojiSelected(Emoji emoji) {
    Runes runes = emoji.toString().runes;
    int codePoint = runes.elementAt(7);
    String emojiInHex = codePoint.toRadixString(16);
    setState(() {
      emojiSelected = emojiInHex;
      emojiShowing = false;
      if (statusString.isEmpty || emojiSelected == "") {
        _buttonEnabled = false;
      } else {
        _buttonEnabled = true;
      }
    });
  }

  void _onTextFieldChanged(String value) {
    setState(() {
      statusString = value;
      if (statusString.isEmpty || emojiSelected == "") {
        _buttonEnabled = false;
      } else {
        _buttonEnabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<UserList> user = Provider.of<CreatedProvider>(context).getUserInfo();
    List<UserList> selectedUser =
        Provider.of<SelectedProvider>(context).getUserProfile();
    List changeStatus = [];

    void _changeStatus() async {
      List<UserList> updateStatus = [];
      changeStatus.add(emojiSelected);
      changeStatus.add(statusString);

      updateStatus.add(
        UserList(
          user[0].seq,
          user[0].name,
          user[0].email,
          user[0].phone,
          user[0].image,
          user[0].status,
          changeStatus,
          user[0].time,
          user[0].introduce,
        ),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> updatedUserData =
          updateStatus.map((user) => jsonEncode(user.toJson())).toList();
      await prefs.setStringList('user', updatedUserData);

      setState(() {
        Navigator.of(context).pop();
        Provider.of<CreatedProvider>(context, listen: false).loadUserInfo();
        Provider.of<SelectedProvider>(context, listen: false).selectedSet("");
        if (selectedUser.isNotEmpty && selectedUser[0].seq == user[0].seq) {
          Provider.of<SelectedProvider>(context, listen: false)
              .resetUserProfile();
          Provider.of<SelectedProvider>(context, listen: false)
              .selectedUserProfile(updateStatus[0]);
        }
      });
    }

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
                    icon: const Icon(Icons.close),
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
                                _changeStatus();
                              }
                            : null,
                        child: Text(
                          "저장",
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
                          ? Icons.tag_faces
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
                      labelText: "상태를 입력해 주세요.",
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
                      hintText: "상태를 입력해 주세요.",
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
