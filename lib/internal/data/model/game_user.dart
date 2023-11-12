import 'package:villagerio/internal/data/model/game_role.dart';
import 'package:villagerio/internal/data/model/user.dart';

class GameUser {
  final User user;
  bool isKilled;
  bool isVoted;
  GameRole? role;

  GameUser(this.user, {this.isKilled = false, this.role, this.isVoted = false});
}
