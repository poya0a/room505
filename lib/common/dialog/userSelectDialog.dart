import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room505/config/palette.dart';
import 'package:room505/selected.dart';
import 'package:room505/common/dialog/createChatDialog.dart';
import 'package:room505/temp/tempClass.dart';
import 'package:room505/temp/tempUserList.dart';

class UserSelectDialog extends StatefulWidget {
  const UserSelectDialog({super.key});

  @override
  State<UserSelectDialog> createState() => _UserSelectDialogState();
}

class _UserSelectDialogState extends State<UserSelectDialog> {
  ScrollController _scrollController = ScrollController();
  final List<User> users = generateTempUserList();
  List<User> userList = [];
  List<int> checkedSeq = [];

  bool _checked = false;
  bool _buttonEnabled = false;

  void _addUser(User userData) {
    final userToAdd =
        AddList(userData.seq, userData.name, userData.email, userData.image);
    final userList = Provider.of<SelectedProvider>(context, listen: false);
    userList.addUser(userToAdd);
  }

  void _removeUser(userSeq) {
    final userList = Provider.of<SelectedProvider>(context, listen: false);
    userList.removeUser(userSeq);
  }

  void _searchUser(String searchValue) {
    setState(() {
      if (searchValue.isEmpty) {
        userList = users;
      } else {
        userList = users
            .where(
              (user) => user.name.toLowerCase().contains(
                    searchValue.toLowerCase(),
                  ),
            )
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
    userList = List.from(users);
    if (Provider.of<SelectedProvider>(context, listen: false)
        .getAddList()
        .isNotEmpty) {
      checkedSeq = Provider.of<SelectedProvider>(context, listen: false)
          .getAddList()
          .map((item) => item.seq)
          .toList();
      _buttonEnabled = true;
    }
    Provider.of<SelectedProvider>(context, listen: false)
        .selectedPosition(0.0, 0.0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final addList = Provider.of<SelectedProvider>(context).getAddList();
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
                                    image: AssetImage(addUser.image),
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
                                _removeUser(addUser.seq);
                                setState(() {
                                  checkedSeq.remove(addUser.seq);
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
                      _searchUser(value);
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
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    final user = userList[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _checked = !_checked;
                          if (checkedSeq.contains(user.seq)) {
                            checkedSeq.remove(user.seq);
                            _removeUser(user.seq);
                          } else {
                            checkedSeq.add(user.seq);
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
                        padding: EdgeInsets.all(10),
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
                                color: checkedSeq.contains(user.seq)
                                    ? Palette.mainColor
                                    : Colors.transparent,
                              ),
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: checkedSeq.contains(user.seq)
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: AssetImage(user.image),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Text(
                              user.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: user.status
                                    ? Palette.greenColor
                                    : Palette.textSub,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
