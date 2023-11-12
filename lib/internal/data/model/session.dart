import 'package:villagerio/internal/data/enum/mode.dart';
import 'package:villagerio/internal/data/model/room.dart';
import 'package:villagerio/internal/data/model/user.dart';

class Session {
  User? user;
  Room? room;
  Mode? mode;

  Session({this.user, this.room, this.mode});

  Session copyWith(
      {User? user,
      Room? room,
      Mode? joinPathState,
      bool unsetUser = false,
      unsetRoomId = false,
      unsetMode = false}) {
    return Session(
        user: user ?? (!unsetUser ? this.user : null),
        room: room ?? (!unsetRoomId ? this.room : null),
        mode: joinPathState ?? (!unsetMode ? this.mode : null));
  }

  Session withValue(
      {User? user,
      Room? room,
      Mode? mode,
      bool unsetUser = false,
      unsetRoom = false,
      unsetJoinPathState = false}) {
    this.user = user ?? (!unsetUser ? this.user : null);
    this.room = room ?? (!unsetRoom ? this.room : null);
    this.mode = mode ?? (!unsetJoinPathState ? this.mode : null);
    return this;
  }

  bool isHost() {
    if (room == null || user == null) return false;
    return room!.isHostOfThisRoom(user!);
  }

  @override
  String toString() {
    return '{"user":$user,"room":$room,"mode":"$mode"}';
  }
}
