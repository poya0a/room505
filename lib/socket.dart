import 'package:flutter/material.dart';
import 'package:room505/screen/chatRoom/chatClass.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider with ChangeNotifier {
  late IO.Socket socket;

  void connectToSocket() {
    print('connectToSocket');
    socket = IO.io('http://localhost:3002'
        // , <String, dynamic>{
        //   'transports': ['websocket'],
        // }
        );
    //socket.connect();
    // socket.onPing((data) => print(data.toString()));
    socket.onConnect((_) {
      print('Connected to Socket');
      print(socket.connected);
    });

    // socket.on('send_msg', (data) {
    //   print('Received message: $data');
    // });

    socket.onDisconnect((_) {
      print('Disconnected from Socket');
    });
    //print(socket.connected);
    //notifyListeners();
  }

  void myInfo(
    String id,
    String uid,
    String deviceKey,
  ) {
    final Map<dynamic, String> myData = {
      "id": id,
      "uid": uid,
      "device": "WEB",
      "devicekey": deviceKey,
    };
    socket.emit('myinfo', myData);
    print("myinfo");
    print(socket.connected);
  }

  void joinRoom(String roomKey, String uid) {
    socket.emit('joinroom',
        {'type': 'join', 'roomkey': roomKey, 'uid': uid, 'device': 'WEB'});
    print(socket.connected);
  }

  void sendMessage(Message message) {
    socket.emit('send_msg', message.toMap());
    print(socket.connected);
  }
}
