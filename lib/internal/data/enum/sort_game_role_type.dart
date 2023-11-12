import 'package:flutter_gen/gen_l10n/lang.dart';

enum SortGameRoleType {
  name,
  favorite,
  played,
  points;

  const SortGameRoleType();
}

extension ParseSortGameRoleType on SortGameRoleType {
  String toStringLang(AppLang str) {
    switch (this) {
      case SortGameRoleType.name:
        return str.name;
      case SortGameRoleType.favorite:
        return str.favorite;
      case SortGameRoleType.played:
        return str.played;
      case SortGameRoleType.points:
        return str.points;
      default:
    }

    return str.unimplemented;
  }
}
