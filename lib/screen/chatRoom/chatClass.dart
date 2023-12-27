class Emps {
  final String _id;
  final String uid;
  final String name;
  final String email;
  final String birth;
  final String phone;
  final String image;
  final bool status;
  final List<dynamic> updateStatus;
  final String introduce;
  final String company;
  final String dept;

  Emps(
    this._id,
    this.uid,
    this.name,
    this.email,
    this.birth,
    this.phone,
    this.image,
    this.status,
    this.updateStatus,
    this.introduce,
    this.company,
    this.dept,
  );

  Map<String, dynamic> toJson() {
    return {
      '_id': _id,
      'uid': uid,
      'name': name,
      'email': email,
      'birth': birth,
      'phone': phone,
      'image': image,
      'status': status,
      'updateStatus': updateStatus,
      'introduce': introduce,
      'company': company,
      'dept': dept,
    };
  }

  factory Emps.fromJson(Map<String, dynamic> json) {
    return Emps(
      json['_id'],
      json['UID'],
      json['USER_NAME'],
      json['USER_ID'],
      json['USER_BIRTH'],
      json['MOBILE_NUM'],
      json['USER_PROFILE'],
      json['USER_STATE'],
      json['USER_STATUS'],
      json['USER_INTRODUCE'],
      json['COMPANY_CODE'],
      json['DEPT_CODE'],
    );
  }
}

class Dept {
  final String code;
  final String name;
  final List<Emps> emps;

  Dept(
    this.code,
    this.name,
    this.emps,
  );

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'emps': emps,
    };
  }

  factory Dept.fromJson(Map<String, dynamic> json) {
    return Dept(
      json['DEPT_CODE'],
      json['DEPT_NAME'],
      (json['EMPS'] as List<dynamic>)
          .map((user) => Emps.fromJson(user))
          .toList(),
    );
  }
}

class ChatList {
  final List<Member> member;
  final String roomKey;
  final String roomLastChatType;
  final String roomLastMsg;
  final int roomLastUnixtime;
  final String roomType;

  ChatList(
    this.member,
    this.roomKey,
    this.roomLastChatType,
    this.roomLastMsg,
    this.roomLastUnixtime,
    this.roomType,
  );

  factory ChatList.fromJson(Map<dynamic, dynamic> json) {
    return ChatList(
      (json['MEMBER'] as List<dynamic>)
          .map((userJson) => Member.fromJson(userJson))
          .toList(),
      json['ROOM_KEY'],
      json['ROOM_LAST_CHAT_TYPE'],
      json['ROOM_LAST_MSG'],
      json['ROOM_LAST_UNIXTIME'],
      json['ROOM_TYPE'],
    );
  }
}

class Chats {
  final String _id;
  final String chatIndex;
  final String chatType;
  final String msg;
  final List<int> readMember;
  final String roomKey;
  final String uid;
  final int unread;
  final List<Member> unreadMember;
  final String userName;
  final DateTime writeDate;
  final int writeUnixtime;
  bool timeCheck;

  Chats(
      this._id,
      this.chatIndex,
      this.chatType,
      this.msg,
      this.readMember,
      this.roomKey,
      this.uid,
      this.unread,
      this.unreadMember,
      this.userName,
      this.writeDate,
      this.writeUnixtime,
      {this.timeCheck = true});

  Map<String, dynamic> toJson() {
    return {
      '_id': _id,
      'chatIndex': chatIndex,
      'chatType': chatType,
      'msg': msg,
      'readMember': readMember,
      'roomKey': roomKey,
      'uid': uid,
      'unread': unread,
      'unreadMember': unreadMember,
      'userName': userName,
      'writeDate': writeDate,
      'writeUnixtime': writeUnixtime,
      'timeCheck': timeCheck,
    };
  }

  factory Chats.fromJson(Map<String, dynamic> json) {
    return Chats(
      json['_id'],
      json['CHAT_INDEX'],
      json['CHAT_TYPE'],
      json['MSG'],
      json['READ_MEMBER'],
      json['ROOM_KEY'],
      json['UID'],
      json['UNREAD'],
      (json['UNREAD_MEMBER'] as List<dynamic>)
          .map((userJson) => Member.fromJson(userJson))
          .toList(),
      json['USER_NAME'],
      json['WRITE_DATE'],
      json['WRITE_UNIXTIME'],
      timeCheck: json['TIME_CHECK'] ?? true,
    );
  }
}

class Member {
  final String uid;
  final String userName;
  final String roomName;
  final String roomEmoji;
  final String roomNameChange;
  final String roomEmojiChange;
  final int roomEntraceDate;
  final String lastReadMsg;
  final int lastUnixtime;

  Member(
      this.uid,
      this.userName,
      this.roomName,
      this.roomEmoji,
      this.roomNameChange,
      this.roomEmojiChange,
      this.roomEntraceDate,
      this.lastReadMsg,
      this.lastUnixtime);

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userName': userName,
      'roomName': roomName,
      'roomEmoji': roomEmoji,
      'roomNameChange': roomNameChange,
      'roomEmojiChange': roomEmojiChange,
      'roomEntraceDate': roomEntraceDate,
      'lastReadMsg': lastReadMsg,
      'lastUnixtime': lastUnixtime,
    };
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      json['UID'],
      json['USER_NAME'],
      json['ROOM_NAME'],
      json['ROOM_EMOJI'],
      json['ROOM_NAME_CHG'],
      json['ROOM_EMOJI_CHG'],
      json['ROOM_ENTRANCE_DATE'],
      json['LAST_READ_MSG'],
      json['LAST_UNIXTIME'],
    );
  }
}

class Message {
  final String chatType;
  final String roomKey;
  final String tmpIndex;
  final String chatIndex;
  final String uid;
  final String userName;
  final String msgOri;
  final String msg;
  final String device;

  Message(this.chatType, this.roomKey, this.tmpIndex, this.chatIndex, this.uid,
      this.userName, this.msgOri, this.msg, this.device);

  Map<String, dynamic> toMap() {
    return {
      'chattype': chatType,
      'roomkey': roomKey,
      'tmpIndex': tmpIndex,
      'chatindex': chatIndex,
      'uid': uid,
      'user_name': userName,
      'msgori': msgOri,
      'msg': msg,
      'device': device,
    };
  }
}
