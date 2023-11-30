import 'package:flutter/material.dart';
import 'package:room505/temp/tempClass.dart';

class SelectedProvider extends ChangeNotifier {
  bool _exitApp = false;
  String _menu = '';
  bool _showOverlay = false;
  int _room = 0;
  double _positionTop = 0.0;
  double _positionLeft = 0.0;
  List<AddList> addList = [];
  List<UserList> userlist = [];
  String _setMenu = '';

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

  void selectedOverlay(bool showOverlay) {
    _showOverlay = showOverlay;
    notifyListeners();
  }

  void selectedRoom(int room) {
    _room = room;
    notifyListeners();
  }

  bool getExitApp() {
    return _exitApp;
  }

  String getMenu() {
    return _menu;
  }

  bool getShowOverlay() {
    return _showOverlay;
  }

  int getRoom() {
    return _room;
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

  String getSetMenu() {
    return _setMenu;
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
