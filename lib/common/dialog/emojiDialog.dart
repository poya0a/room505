import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:room505/config/palette.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';

class EmojiDiaolg extends StatefulWidget {
  const EmojiDiaolg({super.key});

  @override
  State<EmojiDiaolg> createState() => _EmojiDiaolgState();
}

class _EmojiDiaolgState extends State<EmojiDiaolg> {
  @override
  Widget build(BuildContext context) {
    void emojiSelected(Emoji emoji) {
      Provider.of<SelectedProvider>(context, listen: false)
          .selectedEmoji(emoji);
      Provider.of<SelectedProvider>(context, listen: false).selectedSet("");
    }

    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GestureDetector(
            onTap: () {
              Provider.of<SelectedProvider>(context, listen: false)
                  .selectedSet("");
            },
          ),
        ),
        Positioned(
          left: 20,
          bottom: 60,
          child: Container(
            width: 300,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              ),
              border: Border.all(
                color: Theme.of(context).shadowColor,
                width: 1,
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  emojiSelected(emoji);
                },
                config: Config(
                  columns: 7,
                  emojiSizeMax: 16 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
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
        )
      ],
    );
  }
}
