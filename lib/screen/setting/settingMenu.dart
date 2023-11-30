import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';
import 'package:room505/main.dart';

class SettingMenu extends StatefulWidget {
  const SettingMenu({super.key});

  @override
  State<SettingMenu> createState() => _SettingMenuState();
}

class _SettingMenuState extends State<SettingMenu> {
  String menuHover = "";

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    setState(() {
      Provider.of<CreatedProvider>(context, listen: false).loadUserInfo();
      Provider.of<SelectedProvider>(context, listen: false).selectedSet("");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const App(),
        ),
      );
    });
  }

  // 앱 종료 함수
  void _exitApp(BuildContext context, logout) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('앱 종료'),
          content: const Text('앱을 종료하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (logout) {
                  _logout();
                }
                setState(() {
                  Provider.of<SelectedProvider>(context).setExitApp(true);
                  Provider.of<SelectedProvider>(context, listen: false)
                      .getExitApp();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const App(),
                    ),
                  );
                });
              },
              child: const Text('종료'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MouseRegion(
          onEnter: (_) {
            setState(() {
              menuHover = "";
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GestureDetector(
              onTap: () {
                Provider.of<SelectedProvider>(context, listen: false)
                    .selectedSet("");
              },
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 20,
          child: Container(
            width: 80,
            height: 101,
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
            child: Column(
              children: [
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "logout";
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      _logout();
                    },
                    child: Container(
                      width: 80,
                      height: 33,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).shadowColor,
                            width: 1,
                          ),
                        ),
                        color: menuHover == "logout"
                            ? Theme.of(context).shadowColor
                            : Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: const Text("로그아웃"),
                    ),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "close";
                    });
                  },
                  child: GestureDetector(
                    onTap: () async {
                      _exitApp(context, false);
                    },
                    child: Container(
                      width: 80,
                      height: 33,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).shadowColor,
                            width: 1,
                          ),
                        ),
                        color: menuHover == "close"
                            ? Theme.of(context).shadowColor
                            : Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: const Text("닫기"),
                    ),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "exit";
                    });
                  },
                  child: GestureDetector(
                    onTap: () async {
                      _exitApp(context, true);
                    },
                    child: Container(
                      width: 80,
                      height: 33,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      color: menuHover == "exit"
                          ? Theme.of(context).shadowColor
                          : Theme.of(context).scaffoldBackgroundColor,
                      child: const Text("종료"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
