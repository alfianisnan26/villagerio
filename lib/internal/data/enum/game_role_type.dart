import 'package:flutter_gen/gen_l10n/lang.dart';

enum GameRoleType {
  villagerTeam,
  werewolfTeam,
  otherTeam,
  independent,
}

extension ParseGameRoleType on GameRoleType {
  String getName(AppLang str) {
    switch (this) {
      case GameRoleType.villagerTeam:
        return str.villagerTeam;
      case GameRoleType.werewolfTeam:
        return str.werewolfTeam;
      case GameRoleType.otherTeam:
        return str.otherTeam;
      case GameRoleType.independent:
        return str.independent;
      default:
    }

    return str.unimplemented;
  }
}
