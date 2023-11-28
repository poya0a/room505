import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';

class SettingMenu extends StatefulWidget {
  const SettingMenu({super.key});

  @override
  State<SettingMenu> createState() => _SettingMenuState();
}

class _SettingMenuState extends State<SettingMenu> {
  String menuHover = "";

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
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "close";
                    });
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
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "end";
                    });
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
                      color: menuHover == "end"
                          ? Theme.of(context).shadowColor
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: const Text("종료"),
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
