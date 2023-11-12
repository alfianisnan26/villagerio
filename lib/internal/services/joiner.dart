import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:villagerio/internal/data/enum/mode.dart';
import 'package:villagerio/internal/data/model/session.dart';
import 'package:villagerio/internal/services/window.dart';

enum JoinerState { idle, joining, error, success }

class JoinerService extends Cubit<JoinerState> {
  JoinerService() : super(JoinerState.idle);
  Future<bool> _join() async {
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }

  Future<JoinerState> join(int roomId) async {
    emit(JoinerState.joining);
    if (await _join()) return JoinerState.success;

    emit(JoinerState.error);
    return state;
  }

  factory JoinerService.of(BuildContext context) {
    return context.read<JoinerService>();
  }

  void setIdle() {
    emit(JoinerState.idle);
  }

  static String constructJoinUrl(Session session, {Mode mode = Mode.userMode}) {
    return "${WindowService.getDomain()}?roomId=${session.room!.id}&mode=${mode.name}";
  }
}
