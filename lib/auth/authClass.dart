class Term {
  final String _id;
  final String content;
  final String requiredYn;
  final int seq;
  final String title;

  Term(this._id, this.content, this.requiredYn, this.seq, this.title);

  Map<String, dynamic> toJson() {
    return {
      '_id': _id,
      'content': content,
      'requiredYn': requiredYn,
      'seq': seq,
      'title': title,
    };
  }

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      json['_id'],
      json['CONTENT'],
      json['REQUIRED_YN'],
      json['SEQ'],
      json['TITLE'],
    );
  }
}

class User {
  final String _id;
  final String uid;
  final String serach;
  final String userId;
  final String userPwd;
  final String userName;
  final String userBirth;
  final String userProfile;
  final List<dynamic> userStatus;
  final bool userState;
  final String userIntroduce;
  final String mobileNum;
  final String registerYn;
  final List<dynamic> termsSeq;
  final String useYn;
  final String adminYn;
  final int adminLevel;
  final String myArea;
  final List<dynamic> loginInfo;
  // final List<Map<String, dynamic>> writerInfo;
  final int writeUnixtime;
  // final List<Map<String, dynamic>> updateInfo;
  final int updateUnixtime;
  final List<dynamic> loginDevice;
  final String companyCode;
  final String deptCode;

  User(
    this._id,
    this.uid,
    this.serach,
    this.userId,
    this.userPwd,
    this.userName,
    this.userBirth,
    this.userProfile,
    this.userStatus,
    this.userState,
    this.userIntroduce,
    this.mobileNum,
    this.registerYn,
    this.termsSeq,
    this.useYn,
    this.adminYn,
    this.adminLevel,
    this.myArea,
    this.loginInfo,
    // this.writerInfo,
    this.writeUnixtime,
    // this.updateInfo,
    this.updateUnixtime,
    this.loginDevice,
    this.companyCode,
    this.deptCode,
  );

  Map<String, dynamic> toJson() {
    return {
      '_id': _id,
      'uid': uid,
      'serach': serach,
      'userId': userId,
      'userPwd': userPwd,
      'userName': userName,
      'userBirth': userBirth,
      'userProfile': userProfile,
      'userStatus': userStatus,
      'userState': userState,
      'userIntroduce': userIntroduce,
      'mobileNum': mobileNum,
      'registerYn': registerYn,
      'termsSeq': termsSeq,
      'useYn': useYn,
      'adminYn': adminYn,
      'adminLevel': adminLevel,
      'myArea': myArea,
      'loginInfo': loginInfo,
      // 'writerIno': writerInfo,
      'writeUnixtime': writeUnixtime,
      // 'updateInfo': updateInfo,
      'updateUnixtime': updateUnixtime,
      'loginDevice': loginDevice,
      'companyCode': companyCode,
      'deptCode': deptCode,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['_id'],
      json['UID'],
      json['SEARCH'],
      json['USER_ID'],
      json['USER_PWD'],
      json['USER_NAME'],
      json['USER_BIRTH'],
      json['USER_PROFILE'],
      json['USER_STATUS'],
      json['USER_STATE'],
      json['USER_INTRODUCE'],
      json['MOBILE_NUM'],
      json['REGISTER_YN'],
      json['TERMS_SEQ'],
      json['USE_YN'],
      json['ADMIN_YN'],
      json['ADMIN_LEVEL'],
      json['MY_AREA'],
      json['LOGIN_INFO'],
      // json['WRITER_INFO'],
      json['WRITE_UNIXTIME'],
      // json['UPDATER_INFO'],
      json['UPDATE_UNIXTIME'],
      json['LOGIN_DEVICE'],
      json['COMPANY_CODE'],
      json['DEPT_CODE'],
    );
  }
}

class Company {
  final String _id;
  final String code;
  final String name;
  final String useYn;

  Company(this._id, this.code, this.name, this.useYn);

  Map<String, dynamic> toJson() {
    return {
      '_id': _id,
      'code': code,
      'name': name,
      'useYn': useYn,
    };
  }

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      json['_id'],
      json['COMPANY_CODE'],
      json['COMPANY_NAME'],
      json['USE_YN'],
    );
  }
}
