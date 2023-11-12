import 'package:villagerio/internal/data/enum/game_time_event_type.dart';
import 'package:villagerio/internal/data/model/game_user.dart';

class GameSession {
  int day = 0;
  GameTimeEventType timeEventType = GameTimeEventType.introduction;
  final List<GameUser> user;

  GameSession(
      {this.day = 0,
      this.timeEventType = GameTimeEventType.introduction,
      this.user = const []});
}
