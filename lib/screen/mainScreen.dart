import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/cupertino.dart';
import 'package:room505/config/palette.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';
import 'package:room505/temp/tempClass.dart';
import 'package:room505/mediaQuery.dart';
import 'package:room505/auth/login.dart';
import 'package:room505/screen/user/userMenu.dart';
import 'package:room505/common/overlayMenu.dart';
import 'package:room505/screen/menu/More.dart';
import 'package:room505/screen/menu/connect.dart';
import 'package:room505/screen/menu/document.dart';
import 'package:room505/screen/menu/file.dart';
import 'package:room505/screen/chatRoom/chatRoom.dart';
import 'package:room505/screen/setting/settingMenu.dart';
import 'package:room505/screen/setting/settingProfile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    List<UserList> user = Provider.of<CreatedProvider>(context).getUserInfo();
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    final _width = Provider.of<MediaQueryProvider>(context).getUseMenuWidth();
    final selectedProvider = Provider.of<SelectedProvider>(context);
    String selectedMenu = selectedProvider.getMenu();
    String selectedSetMenu = selectedProvider.getSetMenu();
    double top = selectedProvider.getPositionTop();
    double left = selectedProvider.getPositionLeft();
    final chatList = Provider.of<CreatedProvider>(context).getChatList();
    bool selectedChat = chatList.any((chat) => chat.name == selectedMenu);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).shadowColor,
        title: Center(
          child: Text(
            'ROOM 505',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (selectedSetMenu == "settingProfile") {
                Provider.of<SelectedProvider>(context, listen: false)
                    .selectedSet("");
              } else {
                Provider.of<SelectedProvider>(context, listen: false)
                    .selectedSet("settingProfile");
              }
            },
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 20.0, 5),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.asset(
                        user.isNotEmpty && user[0].image.isNotEmpty
                            ? user[0].image
                            : '../../images/profile.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 15,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: user.isNotEmpty && user[0].status
                          ? Palette.greenColor
                          : Palette.textSub,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        leading: GestureDetector(
          onTap: () {
            if (selectedSetMenu == "settingMenu") {
              Provider.of<SelectedProvider>(context, listen: false)
                  .selectedSet("");
            } else {
              Provider.of<SelectedProvider>(context, listen: false)
                  .selectedSet("settingMenu");
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              CupertinoIcons.bars,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: _width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).shadowColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: const UserMenu(),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          Provider.of<MediaQueryProvider>(context,
                                  listen: false)
                              .controlUseMenuWidth(details.delta.dx);
                        });
                      },
                      onPanEnd: (details) {
                        Future.delayed(
                            Provider.of<MediaQueryProvider>(context,
                                    listen: false)
                                .delay, () {
                          setState(() {
                            Provider.of<MediaQueryProvider>(context,
                                    listen: false)
                                .hideUseMenuWidth();
                          });
                        });
                      },
                      child: Container(
                        width: 5,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.transparent,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.resizeColumn,
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                  if (selectedSetMenu == "settingMenu") const SettingMenu(),
                  if (selectedSetMenu == "settingProfile")
                    const SettingProfile(),
                  if (top != 0.0 && left != 0.0 && _width != 0)
                    const OverlayMenu(),
                ],
              ),
              if (selectedMenu == "document") const Document(),
              if (selectedMenu == "file") const File(),
              if (selectedMenu == "connect") const Connect(),
              if (selectedMenu == "more") const More(),
              if (selectedChat) const ChatRoom(),
            ],
          ),
        ),
      ),
    );
  }
}
