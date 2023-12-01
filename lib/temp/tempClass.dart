import 'package:room505/selected.dart';

class UserList {
  final int seq;
  final String name;
  final String email;
  final String phone;
  final String image;
  final bool status;
  final List updateStatus;
  final String time;
  final String introduce;

  UserList(this.seq, this.name, this.email, this.phone, this.image, this.status,
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

  factory UserList.fromJson(Map<String, dynamic> json) {
    return UserList(
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
  final int sortingNumber;
  final String name;
  final String emoji;
  final List<AddList> userList;

  ChatList(this.seq, this.sortingNumber, this.name, this.emoji, this.userList);

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'sortingNumber': sortingNumber,
      'name': name,
      'emoji': emoji,
      'userList': userList.map((user) => user.toJson()).toList(),
    };
  }

  factory ChatList.fromJson(Map<String, dynamic> json) {
    return ChatList(
      json['seq'],
      json['sortingNumber'],
      json['name'],
      json['emoji'],
      (json['userList'] as List<dynamic>)
          .map((userJson) => AddList.fromJson(userJson))
          .toList(),
    );
  }
}
