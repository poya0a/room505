import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:do_it/temp/tempClass.dart';

class CreatedProvider extends ChangeNotifier {
  List<RoomList> roomList = [];
  List<ChatList> chatList = [];
  List<String> chat = [];

  void loadRoomList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? roomListJson = prefs.getStringList('roomList');
    if (roomListJson != null) {
      roomList = roomListJson
          .map((jsonString) => RoomList.fromJson(jsonDecode(jsonString)))
          .toList();
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

  List<RoomList> getRoomList() {
    return roomList;
  }

  List<ChatList> getChatList() {
    return chatList;
  }

  List<String> getChat() {
    return chat;
  }
}
