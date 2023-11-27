import 'package:room505/selected.dart';

class UserList {
  final int seq;
  final String name;
  final String email;
  final String phone;
  final String image;
  final bool status;
  final String time;

  UserList(this.seq, this.name, this.email, this.phone, this.image, this.status,
      this.time);

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'status': status,
      'time': time,
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
      json['time'],
    );
  }
}

class RoomList {
  final int sortingNumber;
  final int seq;
  final String name;
  final String emoji;
  final List<int> chatSeqList;

  RoomList(
      this.sortingNumber, this.seq, this.name, this.emoji, this.chatSeqList);

  Map<String, dynamic> toJson() {
    return {
      'sortingNumber': sortingNumber,
      'seq': seq,
      'name': name,
      'emoji': emoji,
      'chatSeqList': chatSeqList,
    };
  }

  factory RoomList.fromJson(Map<String, dynamic> json) {
    return RoomList(json['sortingNumber'], json['seq'], json['name'],
        json['emoji'], (json['chatSeqList'] as List<dynamic>).cast<int>());
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
