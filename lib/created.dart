import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:room505/temp/tempClass.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class CreatedProvider extends ChangeNotifier {
  late IO.Socket socket;
  User userInfo = User(0, '', '', '', '', false, [], '', '');
  List<ChatList> chatList = [];
  int totalCount = 0;

  void loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? userJson = prefs.getStringList('user');
    if (userJson != null) {
      userInfo = User.fromJson(jsonDecode(userJson.first));
    } else {
      userInfo = User(0, '', '', '', '', false, [], '', '');
    }
    notifyListeners();
  }

  void loadChatList() async {
    socket = IO.io('http://localhost:3000');
    socket.connect();

    const String url = 'http://localhost:3000/getChatRooms';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'user-seq': userInfo.seq.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final resultValue = responseData['result'];
        if (resultValue != null && resultValue is bool) {
          if (resultValue) {
            socket.on('chatRoomsList', (data) {
              if (data is List && data.isNotEmpty) {
                chatList = data
                    .map((chatRoom) => ChatList.fromJson(chatRoom))
                    .toList();
              }
            });
          }
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void loadChats(int chatSeq, int countNumber) async {
    socket = IO.io('http://localhost:3000');
    socket.connect();

    final String url = 'http://localhost:3000/getChats?totalCount=$countNumber';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'chat-seq': chatSeq.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final resultValue = responseData['result'];
        if (resultValue != null && resultValue is bool) {
          if (resultValue) {
            socket.on('message_' + chatSeq.toString(), (data) {
              setTotalCount(data['totalCount']);
            });
          }
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void setTotalCount(int countNumber) {
    totalCount = countNumber;
    notifyListeners();
  }

  User getUserInfo() {
    return userInfo;
  }

  List<ChatList> getChatList() {
    return chatList;
  }

  int getTotalCount() {
    return totalCount;
  }
}
