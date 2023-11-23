import 'package:flutter/material.dart';
import 'package:do_it/temp/tempClass.dart';

class SelectedProvider extends ChangeNotifier {
  String _menu = '';
  double _positionTop = 0.0;
  double _positionLeft = 0.0;
  List<AddList> addList = [];
  List<UserList> userlist = [];

  void selectedMenu(String menu) {
    if (_menu != menu) {
      _menu = menu;
      notifyListeners();
    }
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
