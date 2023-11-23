import 'package:flutter/material.dart';

class MediaQueryProvider extends ChangeNotifier {
  double _useMenuWidth = 250;

  late Duration delay = Duration.zero;

  void controlUseMenuWidth(double delta) {
    _useMenuWidth += delta;
    if (_useMenuWidth < 200) {
      _useMenuWidth = 200;
      delay = Duration(milliseconds: 100);
    }
    if (_useMenuWidth > 800) {
      _useMenuWidth = 800;
    }

    Future.delayed(delay, () {
      if (_useMenuWidth <= 200) {
        _useMenuWidth = 0;
      }

      delay = Duration.zero;
    });

    notifyListeners();
  }

  void hideUseMenuWidth() {
    if (_useMenuWidth <= 200) {
      _useMenuWidth = 0;
    }

    delay = Duration.zero;

    notifyListeners();
  }

  double getUseMenuWidth() {
    return _useMenuWidth;
  }
}
