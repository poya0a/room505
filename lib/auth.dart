import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  List<int> termsSeq = [];

  void setTermsSeq(List<int> chekcedSeq) {
    termsSeq = chekcedSeq;
    notifyListeners();
  }

  List<int> getTermsSeq() {
    return termsSeq;
  }
}
