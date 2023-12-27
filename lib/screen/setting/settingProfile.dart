import 'package:flutter/material.dart';
import 'package:room505/auth.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';
import 'package:room505/screen/chatRoom/chatClass.dart';
import 'package:room505/auth/authClass.dart';
import 'package:room505/config/palette.dart';
import 'package:room505/common/dialog/changeStatusDialog.dart';

class SettingProfile extends StatefulWidget {
  const SettingProfile({super.key});

  @override
  State<SettingProfile> createState() => _SettingProfileState();
}

class _SettingProfileState extends State<SettingProfile> {
  String menuHover = "";

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<AuthProvider>(context).getUserInfo();
    Emps selectedUser = Provider.of<SelectedProvider>(context).getUserProfile();

    void changeStatus(type) async {
      Emps userInfo = Emps(
          "",
          user.uid,
          user.userName,
          user.userId,
          user.userBirth,
          user.mobileNum,
          user.userProfile,
          type == "switchStatus" ? !user.userState : user.userState,
          type == "removeStatus" ? [] : user.userStatus,
          user.userIntroduce,
          user.companyCode,
          user.deptCode);

      setState(() {
        Provider.of<SelectedProvider>(context, listen: false).selectedSet("");
        if (selectedUser.uid != "" && selectedUser.uid == user.uid) {
          Provider.of<SelectedProvider>(context, listen: false)
              .resetUserProfile();
          Provider.of<SelectedProvider>(context, listen: false)
              .selectedUserProfile(userInfo);
        }
      });
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
            height: user.userStatus.isEmpty ? 177 : 210,
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
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset(
                              user.userProfile.isNotEmpty
                                  ? user.userProfile
                                  : 'images/profile.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                user.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: user.userState
                                        ? Palette.greenColor
                                        : Palette.textSub,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  user.userState ? "대화 가능" : "자리 비움",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "changeStatus";
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ChangeStatusDialog();
                        },
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 43,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          border: Border.all(
                            color: Theme.of(context).shadowColor,
                            width: 1,
                          ),
                          color: menuHover == "changeStatus"
                              ? Theme.of(context).shadowColor
                              : Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              user.userStatus.isEmpty
                                  ? Icons.tag_faces
                                  : IconData(
                                      int.parse(user.userStatus[0], radix: 16),
                                      fontFamily: 'EmojiFontFamily',
                                    ),
                              size: 16,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              user.userStatus.isEmpty
                                  ? "상태 업데이트"
                                  : user.userStatus[1],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (user.userStatus.isNotEmpty)
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        menuHover = "removeStatus";
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        changeStatus("removeStatus");
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
                          color: menuHover == "removeStatus"
                              ? Theme.of(context).shadowColor
                              : Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: const Text("상태 지우기"),
                      ),
                    ),
                  ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "status";
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      changeStatus("switchStatus");
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
                      child: Text(user.userState ? "자리 비움으로 설정" : "대화 가능으로 설정"),
                    ),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      menuHover = "profile";
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      Emps userInfo = Emps(
                          "",
                          user.uid,
                          user.userName,
                          user.userId,
                          user.userBirth,
                          user.mobileNum,
                          user.userProfile,
                          user.userState,
                          user.userStatus,
                          user.userIntroduce,
                          user.companyCode,
                          user.deptCode);

                      Provider.of<SelectedProvider>(context, listen: false)
                          .selectedSet("");
                      Provider.of<SelectedProvider>(context, listen: false)
                          .selectedUserProfile(userInfo);
                    },
                    child: Container(
                      width: 200,
                      height: 33,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      color: menuHover == "profile"
                          ? Theme.of(context).shadowColor
                          : Theme.of(context).scaffoldBackgroundColor,
                      child: const Text("프로필"),
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
