import 'package:flutter_gen/gen_l10n/lang.dart';

enum FilterGameRoleType {
  all,
  villagerTeam,
  werewolfTeam,
  otherTeam,
  independent,
  myFavorite;

  const FilterGameRoleType();
}

extension ParseFilterGameRoleType on FilterGameRoleType {
  String toStringLang(AppLang str) {
    switch (this) {
      case FilterGameRoleType.all:
        return str.all;
      case FilterGameRoleType.villagerTeam:
        return str.villagerTeam;
      case FilterGameRoleType.werewolfTeam:
        return str.werewolfTeam;
      case FilterGameRoleType.otherTeam:
        return str.otherTeam;
      case FilterGameRoleType.independent:
        return str.independent;
      case FilterGameRoleType.myFavorite:
        return str.myFavorite;
      default:
    }

    return str.unimplemented;
  }
}
