// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:villagerio/internal/data/enum/mode.dart';
import 'package:villagerio/internal/data/model/room.dart';
import 'package:villagerio/internal/pkg/logger/logger.dart';

final _log = InternalLogger.instance;

extension ColorString on Color {
  String toHexString() {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}

class WindowService {
  static final _uri = Uri.base;

  static Room? getRoom() {
    final val = int.tryParse(_uri.queryParameters['roomId'] ?? "");
    if (val != null) {
      return Room(id: val);
    }
    return null;
  }

  static Mode? getMode() {
    return ParseMode.fromString(_uri.queryParameters['mode'] ?? "");
  }

  static String getDomain() {
    return "${_uri.scheme}://${_uri.host}${_uri.hasPort ? ":${_uri.port}" : ""}";
  }

  static Future<bool> checkCameraPermission() async {
    _log.d("checking for permission");
    final perm = await window.navigator.permissions!.query({"name": "camera"});
    _log.d("finished checking permission: ${perm.state}");
    return perm.state != "denied";
  }

  static Future<bool> requestCameraPermission() async {
    if (!await checkCameraPermission()) return false;
    _log.d("requesting for permission");
    final media = await window.navigator.getUserMedia(video: true);
    media.getTracks().forEach((element) => element.stop());
    _log.d("finished requesting permission");
    return checkCameraPermission();
  }

  static bool checkPWAInstallation() {
    return js.context.callMethod('checkPWAInstallation') as bool;
  }

  static String getWindowLocaleName() {
    return window.navigator.language;
  }

  static void setMetaThemeColor(Color color) {
    js.context.callMethod("setMetaThemeColor", [color.toHexString()]);
  }

  static void requestFullScreen() {
    window.document.documentElement!.requestFullscreen();
  }

  static void exitFullScreen() {
    window.document.exitFullscreen();
  }
}
