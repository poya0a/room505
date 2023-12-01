import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:room505/temp/tempClass.dart';

class CreatedProvider extends ChangeNotifier {
  List<UserList> userInfo = [];
  List<ChatList> chatList = [];
  List<String> chat = [];

  void loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? userJson = prefs.getStringList('user');
    if (userJson != null) {
      userInfo = userJson
          .map((jsonString) => UserList.fromJson(jsonDecode(jsonString)))
          .toList();
    } else {
      userInfo = [];
    }
    notifyListeners();
  }

  void loadChatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chatListJson = prefs.getStringList('chatList');
    if (chatListJson != null) {
      chatList = chatListJson
          .map((jsonString) => ChatList.fromJson(jsonDecode(jsonString)))
          .toList();
    }
    notifyListeners();
  }

  void loadChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chatJson = prefs.getStringList('chat');
    if (chatJson != null) {
      chat = chatJson;
    }
    notifyListeners();
  }

  List<UserList> getUserInfo() {
    return userInfo;
  }

  List<ChatList> getChatList() {
    return chatList;
  }

  List<String> getChat() {
    return chat;
  }
}
