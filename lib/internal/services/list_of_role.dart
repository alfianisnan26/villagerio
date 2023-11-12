import 'package:villagerio/internal/data/model/game_role.dart';

class ListRoleService {
  static Future<List<GameRoleStats>> getRoleStats() async {
    await Future.delayed(const Duration(seconds: 3));
    return GameRole.values.map((e) => GameRoleStats(e)).toList(growable: false);
  }

  static Future<void> setFavorite(GameRoleStats obj) async {
    obj.isUserFavorite = true;
  }

  static Future<void> unsetFavorite(GameRoleStats obj) async {
    obj.isUserFavorite = false;
  }
}
