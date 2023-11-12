import 'package:villagerio/internal/data/model/game_session.dart';

class GameEvent {
  final GameSession session;

  GameEvent(this.session);
}

// Night event
class GameEventOnActionInitialize extends GameEvent {
  GameEventOnActionInitialize(super.session);
}

class GameEventOnActionPrompt extends GameEvent {
  GameEventOnActionPrompt(super.session);
}

class GameEventOnActionProcess extends GameEvent {
  GameEventOnActionProcess(super.session);
}

// Morting event
class GameEventOnAnnouncementInitialize extends GameEvent {
  GameEventOnAnnouncementInitialize(super.session);
}

// General event
class GameEventOnVoting extends GameEvent {
  GameEventOnVoting(super.session);
}

class GameEventOnKilled extends GameEvent {
  GameEventOnKilled(super.session);
}
