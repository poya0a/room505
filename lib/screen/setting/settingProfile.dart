import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';
import 'package:room505/temp/tempClass.dart';

class SettingProfile extends StatefulWidget {
  const SettingProfile({super.key});

  @override
  State<SettingProfile> createState() => _SettingProfileState();
}

class _SettingProfileState extends State<SettingProfile> {
  String menuHover = "";

  @override
  Widget build(BuildContext context) {
    List<UserList> user = Provider.of<CreatedProvider>(context).getUserInfo();

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
          right: 20,
          child: Container(
            width: 200,
            height: 167,
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
                      menuHover = "";
                    });
                  },
                  child: Container(
                    width: 200,
                    height: 66,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: const Text("생성"),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "status";
                    });
                  },
                  child: GestureDetector(
                    onTap: () async {
                      List<UserList> updateStatus = [];

                      updateStatus.add(
                        UserList(
                          user[0].seq,
                          user[0].name,
                          user[0].email,
                          user[0].phone,
                          user[0].image,
                          !user[0].status,
                          user[0].time,
                        ),
                      );

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      List<String> updatedUserData = updateStatus
                          .map((user) => jsonEncode(user.toJson()))
                          .toList();
                      await prefs.setStringList('user', updatedUserData);

                      setState(() {
                        Provider.of<CreatedProvider>(context, listen: false)
                            .loadUserInfo();
                        Provider.of<SelectedProvider>(context, listen: false)
                            .selectedSet("");
                      });
                    },
                    child: Container(
                      width: 200,
                      height: 33,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).shadowColor,
                            width: 1,
                          ),
                        ),
                        color: menuHover == "status"
                            ? Theme.of(context).shadowColor
                            : Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: user[0].status
                          ? const Text("상태 비활성화")
                          : const Text("상태 활성화"),
                    ),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "profile";
                    });
                  },
                  child: Container(
                    width: 200,
                    height: 33,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).shadowColor,
                          width: 1,
                        ),
                      ),
                      color: menuHover == "profile"
                          ? Theme.of(context).shadowColor
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: const Text("프로필"),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "withdrawal";
                    });
                  },
                  child: Container(
                    width: 200,
                    height: 33,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    color: menuHover == "withdrawal"
                        ? Theme.of(context).shadowColor
                        : Theme.of(context).scaffoldBackgroundColor,
                    child: const Text("회원 탈퇴"),
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
