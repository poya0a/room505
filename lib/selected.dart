import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:room505/screen/chatRoom/chatClass.dart';

class SelectedProvider extends ChangeNotifier {
  bool _exitApp = false;
  String _menu = '';
  double _positionTop = 0.0;
  double _positionLeft = 0.0;
  Emps userProfile = Emps(
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    false,
    [],
    "",
    "",
    "",
  );
  List<AddList> addList = [];
  String _setMenu = '';
  bool _scrollToBottom = true;
  String _roomKey = "";
  Emoji _emoji = const Emoji("", "");
  File _file = File("");

  void setExitApp(bool exitApp) {
    _exitApp = exitApp;
    notifyListeners();
  }

  void selectedMenu(String menu) {
    if (_menu != menu) {
      _menu = menu;
      notifyListeners();
    }
  }

  bool getExitApp() {
    return _exitApp;
  }

  String getMenu() {
    return _menu;
  }

  void selectedPosition(double bottom, double left) {
    _positionTop = bottom;
    _positionLeft = left;
    notifyListeners();
  }

  double getPositionTop() {
    return _positionTop;
  }

  double getPositionLeft() {
    return _positionLeft;
  }

  void selectedUserProfile(Emps user) {
    userProfile = user;
    notifyListeners();
  }

  void resetUserProfile() {
    userProfile = Emps(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      false,
      [],
      "",
      "",
      "",
    );
    notifyListeners();
  }

  Emps getUserProfile() {
    return userProfile;
  }

  void addUser(AddList user) {
    addList.add(user);
    notifyListeners();
  }

  void removeUser(String uid) {
    addList.removeWhere((user) => user.uid == uid);
    notifyListeners();
  }

  List<AddList> getAddList() {
    return addList;
  }

  void resetAddList() {
    addList = [];
    notifyListeners();
  }

  void selectedSet(String setMenu) {
    if (_setMenu != setMenu) {
      _setMenu = setMenu;
      notifyListeners();
    }
  }

  void selectedEmoji(Emoji emoji) {
    _emoji = emoji;
    notifyListeners();
  }

  void selectedFile(File file) {
    _file = file;
    notifyListeners();
  }

  void removeFile() {
    _file = File("");
    notifyListeners();
  }

  String getSetMenu() {
    return _setMenu;
  }

  Emoji getEmoji() {
    return _emoji;
  }

  File getFile() {
    return _file;
  }

  void setScroll(bool scrollToBottom) {
    _scrollToBottom = _scrollToBottom;
  }

  bool getScroll() {
    return _scrollToBottom;
  }
}

class AddList {
  final String uid;
  final String name;
  final String email;
  final String image;

  AddList(this.uid, this.name, this.email, this.image);

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
    };
  }

  factory AddList.fromJson(Map<String, dynamic> json) {
    return AddList(
      json['uid'],
      json['name'],
      json['email'],
      json['image'],
    );
  }
}
