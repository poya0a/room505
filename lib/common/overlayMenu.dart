import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';
import 'package:room505/common/dialog/userSelectDialog.dart';

class OverlayMenu extends StatefulWidget {
  const OverlayMenu({super.key});

  @override
  State<OverlayMenu> createState() => _OverlayMenuState();
}

class _OverlayMenuState extends State<OverlayMenu> {
  String menuHover = "";

  List<Map<String, dynamic>> createMenu = [
    {
      "keyValue": "chatCreate",
      "text": "대화 생성",
      "onTap": (context) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Builder(
              builder: (BuildContext context) {
                return UserSelectDialog();
              },
            );
          },
        );
      },
    }
  ];

  @override
  Widget build(BuildContext context) {
    final selectedProvider = Provider.of<SelectedProvider>(context);
    double top = selectedProvider.getPositionTop();
    double left = selectedProvider.getPositionLeft();

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
                setState(() {
                  Provider.of<SelectedProvider>(context, listen: false)
                      .selectedPosition(0.0, 0.0);
                });
              },
            ),
          ),
        ),
        Positioned(
          top: top - 30,
          left: left,
          child: Container(
            width: 100,
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
                      menuHover = "changeName";
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 33,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).shadowColor,
                          width: 1,
                        ),
                      ),
                      color: menuHover == "changeName"
                          ? Theme.of(context).shadowColor
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: const Text("이름 변경"),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "fixChat";
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 33,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).shadowColor,
                          width: 1,
                        ),
                      ),
                      color: menuHover == "fixChat"
                          ? Theme.of(context).shadowColor
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: const Text("상단 고정"),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "exitChat";
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 33,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    color: menuHover == "exitChat"
                        ? Theme.of(context).shadowColor
                        : Theme.of(context).scaffoldBackgroundColor,
                    child: const Stack(
                      children: [
                        Text("나가기"),
                      ],
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
