import 'package:villagerio/internal/data/model/user.dart';

class Room {
  int? id;
  User? host;

  Room({this.id, this.host});

  bool isHostOfThisRoom(User user) {
    return host == user;
  }

  @override
  String toString() {
    return '{"id":$id, "host":$host}';
  }
}
