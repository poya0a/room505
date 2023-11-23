import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/cupertino.dart';
import 'package:do_it/config/palette.dart';
import 'package:provider/provider.dart';
import 'package:do_it/selected.dart';
import 'package:do_it/created.dart';
import 'package:do_it/mediaQuery.dart';
import 'package:do_it/screen/user/userMenu.dart';
import 'package:do_it/common/overlayMenu.dart';
import 'package:do_it/screen/menu/More.dart';
import 'package:do_it/screen/menu/connect.dart';
import 'package:do_it/screen/menu/document.dart';
import 'package:do_it/screen/menu/file.dart';
import 'package:do_it/screen/chatRoom/chatRoom.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    final _width = Provider.of<MediaQueryProvider>(context).getUseMenuWidth();
    final selectedProvider = Provider.of<SelectedProvider>(context);
    String selectedMenu = selectedProvider.getMenu();
    double top = selectedProvider.getPositionTop();
    double left = selectedProvider.getPositionLeft();
    final chatList = Provider.of<CreatedProvider>(context).getChatList();
    bool selectedChat = chatList.any((chat) => chat.name == selectedMenu);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
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
            onTap: () {},
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
                        '../../images/profile.png',
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
                      color: Palette.greenColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        leading: GestureDetector(
          onTap: () {
            if (screenWidth < 800) {
              setState(() {});
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
                    child: UserMenu(),
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
                  if (top != 0.0 && left != 0.0 && _width != 0) OverlayMenu(),
                ],
              ),
              if (selectedMenu == "document") Document(),
              if (selectedMenu == "file") File(),
              if (selectedMenu == "connect") Connect(),
              if (selectedMenu == "more") More(),
              if (selectedChat) ChatRoom(),
            ],
          ),
        ),
      ),
    );
  }
}
