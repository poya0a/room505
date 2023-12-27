import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:room505/auth.dart';
import 'package:room505/chat.dart';
import 'package:room505/config/palette.dart';
import 'package:room505/selected.dart';
import 'package:room505/common/dialog/createChatDialog.dart';
import 'package:room505/screen/chatRoom/chatClass.dart';

class UserSelectDialog extends StatefulWidget {
  const UserSelectDialog({super.key});

  @override
  State<UserSelectDialog> createState() => _UserSelectDialogState();
}

class _UserSelectDialogState extends State<UserSelectDialog> {
  ScrollController _scrollController = ScrollController();
  List<Dept> userList = [];
  List<String> checkedUser = [];
  String searchValue = "";
  String userUid = "";
  String onTapDept = "";
  List<Emps> searchUser = [];
  bool _initState = true;

  bool _checked = false;
  bool _buttonEnabled = false;

  void _addUser(Emps userData) {
    final userToAdd =
        AddList(userData.uid, userData.name, userData.email, userData.image);
    final userList = Provider.of<SelectedProvider>(context, listen: false);
    userList.addUser(userToAdd);
  }

  void _removeUser(userUid) {
    final userList = Provider.of<SelectedProvider>(context, listen: false);
    userList.removeUser(userUid);
  }

  void selectedDept(String dept) {
    setState(() {
      onTapDept = dept;
    });
  }

  void _searchUser() {
    setState(() {
      if (searchValue.isEmpty) {
        searchUser = [];
      } else {
        searchUser = userList
            .map((dept) => dept.emps.where((user) =>
                user.name.toLowerCase().contains(searchValue.toLowerCase())))
            .expand((emps) => emps)
            .toList();
      }
    });
  }

  void _crateChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateChat();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (Provider.of<SelectedProvider>(context, listen: false)
        .getAddList()
        .isNotEmpty) {
      checkedUser = Provider.of<SelectedProvider>(context, listen: false)
          .getAddList()
          .map((item) => item.uid)
          .toList();
      _buttonEnabled = true;
    }
    Provider.of<SelectedProvider>(context, listen: false)
        .selectedPosition(0.0, 0.0);
    final user = Provider.of<AuthProvider>(context, listen: false).getUser();
    userUid = user['uid']!;
    Provider.of<ChatProvider>(context, listen: false)
        .loadUserList(user!, "", "", 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final addList = Provider.of<SelectedProvider>(context).getAddList();
    userList = Provider.of<ChatProvider>(context).getUserList();
    if (_initState && userList.isNotEmpty) {
      for (var dept in userList) {
        for (var emp in dept.emps) {
          if (emp.uid == userUid) {
            setState(() {
              onTapDept = dept.code;
            });
          }
        }
      }
      _initState = false;
    }
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
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
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        Provider.of<SelectedProvider>(context, listen: false)
                            .resetAddList();
                      });
                    },
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: _buttonEnabled ? Palette.mainColor : Colors.grey,
                      ),
                      child: TextButton(
                        onPressed: _buttonEnabled
                            ? () {
                                Navigator.of(context).pop();
                                _crateChat(context);
                              }
                            : null,
                        child: Text(
                          "확인",
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
            // 선택한 리스트
            if (addList.isNotEmpty)
              Container(
                height: 101,
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: Scrollbar(
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: addList.length,
                    itemBuilder: (context, index) {
                      final addUser = addList[index];
                      return Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: AssetImage(addUser.image != ""
                                        ? addUser.image
                                        : 'images/profile.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                addUser.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 14,
                            child: GestureDetector(
                              onTap: () {
                                _removeUser(addUser.uid);
                                setState(() {
                                  checkedUser.remove(addUser.uid);
                                  if (addList.isNotEmpty) {
                                    _buttonEnabled = true;
                                  } else {
                                    _buttonEnabled = false;
                                  }
                                });
                              },
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  border: Border.all(
                                    color: Palette.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 12,
                                  color: Palette.borderColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            // 검색 창
            Container(
              height: 40,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).shadowColor,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      searchValue = value;
                      _searchUser();
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    hintText: "대화 상대 검색",
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
            // 전체 리스트
            if (searchValue == '' && searchUser.isEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final dept = userList[index];
                      return GestureDetector(
                        onTap: () {
                          if (onTapDept == dept.code) {
                            selectedDept("");
                          } else {
                            selectedDept(dept.code);
                          }
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Transform.rotate(
                                    angle: onTapDept == dept.code
                                        ? 0
                                        : -90 * pi / 180,
                                    child: const Icon(Icons.arrow_drop_down),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    dept.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            if (onTapDept == dept.code)
                              SingleChildScrollView(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: dept.emps.length,
                                  itemBuilder: (context, index) {
                                    final user = dept.emps[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _checked = !_checked;
                                          if (checkedUser.contains(user.uid)) {
                                            checkedUser.remove(user.uid);
                                            _removeUser(user.uid);
                                          } else {
                                            checkedUser.add(user.uid);
                                            _addUser(user);
                                          }
                                          if (addList.isNotEmpty) {
                                            _buttonEnabled = true;
                                          } else {
                                            _buttonEnabled = false;
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 60,
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Palette.mainColor,
                                                  width: 1.0,
                                                ),
                                                color: checkedUser
                                                        .contains(user.uid)
                                                    ? Palette.mainColor
                                                    : Colors.transparent,
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                size: 14,
                                                color: checkedUser
                                                        .contains(user.uid)
                                                    ? Colors.white
                                                    : Colors.transparent,
                                              ),
                                            ),
                                            Stack(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 0, 10, 0),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 20.0, 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    image: DecorationImage(
                                                      image: AssetImage(user
                                                                  .image !=
                                                              ""
                                                          ? user.image
                                                          : 'images/profile.png'),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: -2,
                                                  right: 5,
                                                  child: Container(
                                                    width: 13,
                                                    height: 13,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Theme.of(context)
                                                            .backgroundColor,
                                                        width: 2.0,
                                                      ),
                                                      color: user.status
                                                          ? Palette.greenColor
                                                          : Palette.textSub,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(user.name),
                                            const SizedBox(width: 10),
                                            if (user.uid == userUid)
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 10, 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: Palette.mainColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: const Text(
                                                  '나',
                                                  style: TextStyle(
                                                    color: Palette.mainColor,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (searchValue != '' && searchUser.isNotEmpty)
              SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchUser.length,
                  itemBuilder: (context, index) {
                    final user = searchUser[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _checked = !_checked;
                          if (checkedUser.contains(user.uid)) {
                            checkedUser.remove(user.uid);
                            _removeUser(user.uid);
                          } else {
                            checkedUser.add(user.uid);
                            _addUser(user);
                          }
                          if (addList.isNotEmpty) {
                            _buttonEnabled = true;
                          } else {
                            _buttonEnabled = false;
                          }
                        });
                      },
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Palette.mainColor,
                                  width: 1.0,
                                ),
                                color: checkedUser.contains(user.uid)
                                    ? Palette.mainColor
                                    : Colors.transparent,
                              ),
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: checkedUser.contains(user.uid)
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 20.0, 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: AssetImage(user.image != ""
                                          ? user.image
                                          : 'images/profile.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -2,
                                  right: 5,
                                  child: Container(
                                    width: 13,
                                    height: 13,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            Theme.of(context).backgroundColor,
                                        width: 2.0,
                                      ),
                                      color: user.status
                                          ? Palette.greenColor
                                          : Palette.textSub,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(user.name),
                            const SizedBox(width: 10),
                            if (user.uid == userUid)
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Palette.mainColor,
                                    width: 1,
                                  ),
                                ),
                                child: const Text(
                                  '나',
                                  style: TextStyle(
                                    color: Palette.mainColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
