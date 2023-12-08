import 'package:room505/selected.dart';

class User {
  final int seq;
  final String name;
  final String email;
  final String phone;
  final String image;
  final bool status;
  final List updateStatus;
  final String time;
  final String introduce;

  User(this.seq, this.name, this.email, this.phone, this.image, this.status,
      this.updateStatus, this.time, this.introduce);

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'status': status,
      'updateStatus': updateStatus,
      'time': time,
      'introduce': introduce,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['seq'],
      json['name'],
      json['email'],
      json['phone'],
      json['image'],
      json['status'],
      json['updateStatus'],
      json['time'],
      json['introduce'],
    );
  }
}

class ChatList {
  final int seq;
  final String name;
  final String emoji;
  final List<AddList> userList;

  ChatList(this.seq, this.name, this.emoji, this.userList);

  factory ChatList.fromJson(Map<dynamic, dynamic> json) {
    return ChatList(
      json['seq'],
      json['name'],
      json['emoji'],
      (json['userList'] as List<dynamic>)
          .map((userJson) => AddList.fromJson(userJson))
          .toList(),
    );
  }
}

class Message {
  final int seq;
  final String text;
  final DateTime timestamp;
  final String userName;
  final String userImage;
  late bool timeCheck;

  Message({
    required this.seq,
    required this.text,
    required this.timestamp,
    required this.userName,
    required this.userImage,
    bool? timeCheck,
  }) {
    this.timeCheck = timeCheck ?? true;
  }

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'userName': userName,
      'userImage': userImage,
      'timeCheck': timeCheck,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      seq: json['seq'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      userName: json['userName'],
      userImage: json['userImage'],
      timeCheck: json['timeCheck'],
    );
  }
}
