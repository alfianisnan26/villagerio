import 'package:villagerio/internal/data/model/room.dart';
import 'package:villagerio/internal/data/model/user.dart';
import 'package:villagerio/internal/pkg/helper/random.dart';

class RoomRegistrationService {
  static Future<Room?> createNewRoom(User user) async {
    await Future.delayed(const Duration(seconds: 5));
    return Room(
      id: Random.generateRandomNumber(1000, 9999),
      host: user,
    );
  }
}
