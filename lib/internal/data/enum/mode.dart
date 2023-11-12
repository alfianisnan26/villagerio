enum Mode {
  userMode("user"),
  statsMode("stats"),
  moderatorMode("moderator");

  final String name;
  const Mode(this.name);
}

extension ParseMode on Mode {
  static Mode? fromString(String value) {
    switch (value) {
      case "stats":
        return Mode.statsMode;
      case "moderator":
        return Mode.moderatorMode;
      default:
        return Mode.userMode;
    }
  }
}
