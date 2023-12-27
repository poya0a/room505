import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:room505/auth/authClass.dart';
import 'package:http/http.dart' as http;
import 'package:room505/config/conf.dart';

class AuthProvider extends ChangeNotifier {
  List<int> termsSeq = [];
  String uid = "";
  String devicekey = "";
  User userInfo = User('', '', '', '', '', '', '', '', [], false, '', '', '',
      [], '', '', 0, '', [], 0, 0, [], "", "");
  Company companyInfo = Company("", "", "", "");

  void setTermsSeq(List<int> chekcedSeq) {
    termsSeq = chekcedSeq;
    notifyListeners();
  }

  void loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uidJson = prefs.getString('uid');
    String? devicekeyJson = prefs.getString('devicekey');

    if (uidJson != null && devicekeyJson != null) {
      uid = uidJson;
      devicekey = devicekeyJson;

      final String url = requests("USER_INFO");
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {'fuid': uid, 'devicekey': devicekey},
          ),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final resultCode = responseData['result'];
          final resultData = responseData['data'];
          if (resultCode == "success") {
            if (resultData != null && resultData is Map<String, dynamic>) {
              userInfo = User.fromJson(resultData);
              loadCompanyInfo(userInfo.companyCode);
            }
          }
        }
      } catch (e) {
        print(e);
      }
    }
    notifyListeners();
  }

  void loadCompanyInfo(String code) async {
    final String url = requests("COMPANY_INFO");

    try {
      final response = await http.get(
        Uri.parse(url + '?code=' + code),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final resultCode = responseData['result'];
        final resultData = responseData['data'];
        if (resultCode == "success") {
          if (resultData != null && resultData is Map<String, dynamic>) {
            companyInfo = Company.fromJson(resultData);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  List<int> getTermsSeq() {
    return termsSeq;
  }

  Map<String, String> getUser() {
    final user = {"uid": uid, "devicekey": devicekey};
    return user;
  }

  User getUserInfo() {
    return userInfo;
  }

  Company getCompanyInfo() {
    return companyInfo;
  }
}
