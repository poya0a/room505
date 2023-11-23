import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:do_it/selected.dart';
import 'package:do_it/common/dialog/userSelectDialog.dart';

class OverlayMenu extends StatefulWidget {
  const OverlayMenu({super.key});

  @override
  State<OverlayMenu> createState() => _OverlayMenuState();
}

class _OverlayMenuState extends State<OverlayMenu> {
  String menuHover = "";

  List<Map<String, dynamic>> selectedMenu = [];

  List<Map<String, dynamic>> createMenu = [
    {
      "keyValue": "roomCreate",
      "text": "방 생성",
      "onTap": () {},
    },
    {
      "keyValue": "chatCreate",
      "text": "대화 생성",
      "onTap": (context) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return UserSelectDialog();
          },
        );
      },
    }
  ];

  List<Map<String, dynamic>> settingMenu = [
    {
      "keyValue": "allMute",
      "text": "모두 음소거",
      "onTap": () {},
    },
    {
      "keyValue": "roomName",
      "text": "방 이름 변경",
      "onTap": () {},
    },
    {
      "keyValue": "roomDelete",
      "text": "방 삭제",
      "onTap": () {},
    },
    {
      "keyValue": "roomEdit",
      "text": "모든 방 편집",
      "onTap": () {},
    }
  ];

  List<Map<String, dynamic>> displayMenu = [
    {
      "keyValue": "all",
      "text": "모두 표시",
      "onTap": () {},
    },
    {
      "keyValue": "not",
      "text": "읽지 않은 항목만 표시",
      "onTap": () {},
    },
    {
      "keyValue": "mention",
      "text": "멘션만 표시",
      "onTap": () {},
    },
    {
      "keyValue": "alphabet",
      "text": "알파벳순으로 분류",
      "onTap": () {},
    },
    {
      "keyValue": "recent",
      "text": "최근별로 분리",
      "onTap": () {},
    },
    {
      "keyValue": "priority",
      "text": "우선 순위로 분류",
      "onTap": () {},
    }
  ];

  @override
  Widget build(BuildContext context) {
    final selectedProvider = Provider.of<SelectedProvider>(context);
    double top = selectedProvider.getPositionTop();
    double left = selectedProvider.getPositionLeft();

    List<Map<String, dynamic>> selectedMenu = [];
    if (menuHover == 'create') {
      selectedMenu = createMenu;
    } else if (menuHover == 'setting') {
      selectedMenu = settingMenu;
    } else if (menuHover == 'display') {
      selectedMenu = displayMenu;
    } else {
      selectedMenu = [];
    }

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
                selectedProvider.selectedPosition(0.0, 0.0);
              },
            ),
          ),
        ),
        Positioned(
          top: top - 30,
          left: left,
          child: Container(
            width: 200,
            height: 101,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
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
                      menuHover = "create";
                    });
                  },
                  child: Container(
                    width: 200,
                    height: 33,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).shadowColor,
                          width: 1,
                        ),
                      ),
                      color: menuHover == "create"
                          ? Theme.of(context).shadowColor
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Text("생성"),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "setting";
                    });
                  },
                  child: Container(
                    width: 200,
                    height: 33,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).shadowColor,
                          width: 1,
                        ),
                      ),
                      color: menuHover == "setting"
                          ? Theme.of(context).shadowColor
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Text("관리"),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "display";
                    });
                  },
                  child: Container(
                    width: 200,
                    height: 33,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    color: menuHover == "display"
                        ? Theme.of(context).shadowColor
                        : Theme.of(context).scaffoldBackgroundColor,
                    child: Stack(
                      children: [
                        Text("표시 및 정렬"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (menuHover != "")
          Positioned(
            top: menuHover == "create"
                ? top - 30
                : menuHover == "setting"
                    ? top + 3
                    : top + 36,
            left: left + 200,
            child: Container(
              width: 160,
              height: menuHover == "create"
                  ? 68
                  : menuHover == "setting"
                      ? 134
                      : 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                border: Border.all(
                  color: Theme.of(context).shadowColor,
                  width: 1,
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: OverlaySubMenu(selectedMenu: selectedMenu),
            ),
          ),
      ],
    );
  }
}

class OverlaySubMenu extends StatefulWidget {
  final List<Map<String, dynamic>> selectedMenu;

  OverlaySubMenu({required this.selectedMenu});

  @override
  State<OverlaySubMenu> createState() => _OverlaySubMenuState();
}

class _OverlaySubMenuState extends State<OverlaySubMenu> {
  String subMenuHover = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.selectedMenu
          .map((menuItem) => (MouseRegion(
                onEnter: (_) {
                  setState(() {
                    subMenuHover = menuItem["keyValue"];
                  });
                },
                onExit: (_) {
                  setState(() {
                    subMenuHover = "";
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    (menuItem["onTap"] as void Function(dynamic))(context);
                  },
                  child: Container(
                    width: 160,
                    height: 33,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    color: subMenuHover == menuItem["keyValue"]
                        ? Theme.of(context).shadowColor
                        : Theme.of(context).scaffoldBackgroundColor,
                    child: Text(menuItem["text"]),
                  ),
                ),
              )))
          .toList(),
    );
  }
}
