import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:room505/temp/tempClass.dart';

class SelectedProvider extends ChangeNotifier {
  bool _exitApp = false;
  String _menu = '';
  double _positionTop = 0.0;
  double _positionLeft = 0.0;
  User userProfile = User(0, '', '', '', '', false, [], '', '');
  List<AddList> addList = [];
  String _setMenu = '';
  bool _scrollToBottom = true;
  int _seq = 0;
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

  void selectedUserProfile(User user) {
    userProfile = user;
    notifyListeners();
  }

  void resetUserProfile() {
    userProfile = User(0, '', '', '', '', false, [], '', '');
    notifyListeners();
  }

  User getUserProfile() {
    return userProfile;
  }

  void addUser(AddList user) {
    addList.add(user);
    notifyListeners();
  }

  void removeUser(int seq) {
    addList.removeWhere((user) => user.seq == seq);
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

  void selectedChat(int seq) {
    _seq = seq;
    notifyListeners();
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

  int getChat() {
    return _seq;
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
  final int seq;
  final String name;
  final String email;
  final String image;

  AddList(this.seq, this.name, this.email, this.image);

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'name': name,
      'email': email,
      'image': image,
    };
  }

  factory AddList.fromJson(Map<String, dynamic> json) {
    return AddList(
      json['seq'],
      json['name'],
      json['email'],
      json['image'],
    );
  }
}
