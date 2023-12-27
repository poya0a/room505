import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:room505/screen/chatRoom/chatClass.dart';
import 'package:http/http.dart' as http;
import 'package:room505/config/conf.dart';
import 'package:room505/socket.dart';

class ChatProvider extends ChangeNotifier {
  List<Dept> userList = [];
  List<ChatList> chatList = [];
  ChatList chatRoom = ChatList([], "", "", "", 0, "");
  List<Chats> chats = [];

  void loadUserList(Map<String, String> user, String searchword,
      String searchdepartment, int page) async {
    final String url = requests("USER_LIST");

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'uid': user['uid'],
          'devicekey': user['devicekey'],
          'searchword': searchword,
          'searchdepartment': searchdepartment,
          'userInfo': page,
        },
      ),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final resultCode = responseData['result'];
      final resultData = responseData['data'];
      final resultList = resultData['list'];
      if (resultCode == "success") {
        if (resultList is List && resultList.isNotEmpty) {
          userList = resultList.map((user) => Dept.fromJson(user)).toList();
        }
      }
    }
    notifyListeners();
  }

  void loadChatList(Map<String, String> user) async {
    final String url = requests("ROOM_LIST");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'devicekey': user['devicekey'],
            'force': 'Y',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final resultCode = responseData['result'];
        final resultData = responseData['data'];
        if (resultCode == "success") {
          if (resultData is List && resultData.isNotEmpty) {
            chatList =
                resultData.map((room) => ChatList.fromJson(room)).toList();
          }
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void loadChats(Map<String, String> user, String roomKey) async {
    final String url = requests("CHAT_LIST");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'devicekey': user['devicekey'],
            'roomkey': roomKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final resultValue = responseData['result'];
        final resultData = responseData['data'];
        if (resultValue == "success") {
          if (resultData is List && resultData.isNotEmpty) {
            chats = resultData.map((room) => Chats.fromJson(room)).toList();
          }
          chatRoom = chatList.firstWhere((chat) => chat.roomKey == roomKey,
              orElse: () => ChatList([], "", "", "", 0, ""));
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void sendChats(Map<String, String> user, dynamic msg) async {
    final String url = requests("SEND_MSG");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'devicekey': user['devicekey'],
            'sendMsg': msg,
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final resultValue = responseData['result'];
        final resultData = responseData['data'];
        if (resultValue == "success") {
          if (resultData is List && resultData.isNotEmpty) {
            chats = resultData.map((room) => Chats.fromJson(room)).toList();
          }
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  List<Dept> getUserList() {
    return userList;
  }

  List<ChatList> getChatList() {
    return chatList;
  }

  ChatList getChatRoom() {
    return chatRoom;
  }

  List<Chats> getChats() {
    return chats;
  }
}
