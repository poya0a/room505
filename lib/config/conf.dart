String requests(String req) {
  String apiRoot = "http://localhost:5000";

  Map<String, String> requestMap = {
    "TERMS": '/api/auth/terms',
    "DUPLICATE": '/api/auth/duplicate',
    "AUTHENTICATION": '/api/auth/authentication',
    "RESEND": '/api/auth/resend',
    "LOGIN": '/api/login',
    "AUTH": '/api/auth',
    "USER_INFO": '/api/userinfo',
    "COMPANY_INFO": '/api/auth/userCompany',
    "USER_LIST": '/api/emp/list',
    "ROOM_MAKE": '/api/rooms/make',
    "ROOM_LIST": '/api/rooms/myrooms',
    "CHAT_LIST": '/api/chats/msglist',
    "SEND_MSG": '/api/server/send',
  };

  if (requestMap.containsKey(req)) {
    return apiRoot + requestMap[req]!;
  } else {
    throw Exception('Requested value not found');
  }
}
