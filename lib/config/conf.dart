String requests(String req) {
  String apiRoot = "http://localhost:5000";

  Map<String, String> requestMap = {
    "TERMS": '/api/auth/terms',
    "DUPLICATE": '/api/auth/duplicate',
    "AUTHENTICATION": '/api/auth/authentication',
  };

  if (requestMap.containsKey(req)) {
    return apiRoot + requestMap[req]!;
  } else {
    throw Exception('Requested value not found');
  }
}
