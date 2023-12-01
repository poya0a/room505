import 'package:flutter/material.dart';

class MediaQueryProvider extends ChangeNotifier {
  double _userMenuWidth = 250;
  double _userProfileWidth = 250;

  late Duration delay = Duration.zero;

  void controlUserMenuWidth(double delta) {
    _userMenuWidth += delta;
    if (_userMenuWidth < 200) {
      _userMenuWidth = 200;
      delay = const Duration(milliseconds: 100);
    }
    if (_userMenuWidth > 500) {
      _userMenuWidth = 500;
    }

    notifyListeners();
  }

  void controlUserProfileWidth(double delta) {
    _userProfileWidth -= delta;
    if (_userProfileWidth < 200) {
      _userProfileWidth = 200;
    }
    if (_userProfileWidth > 400) {
      _userProfileWidth = 400;
    }
    notifyListeners();
  }

  void hideUserMenuWidth() {
    if (_userMenuWidth <= 200) {
      _userMenuWidth = 0;
      delay = Duration.zero;
    }

    notifyListeners();
  }

  double getUserMenuWidth() {
    return _userMenuWidth;
  }

  double getUserProfileWidth() {
    return _userProfileWidth;
  }
}
