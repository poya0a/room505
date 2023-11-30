import 'package:room505/temp/tempClass.dart';

List<UserList> generateTempUserList() {
  List<UserList> tempUsers = [];

  for (int i = 1; i <= 30; i++) {
    tempUsers.add(
      UserList(
        i,
        '사용자 $i',
        'user$i@example.com',
        '123-456-78$i',
        'images/profile.png',
        true,
        '${i}:00 AM',
      ),
    );
  }

  return tempUsers;
}
