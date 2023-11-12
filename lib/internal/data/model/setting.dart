import 'package:flutter/material.dart';

class Setting {
  late ThemeMode themeMode;
  late String languageId;

  Setting({ThemeMode? themeMode, String? languageId}) {
    this.themeMode = themeMode ?? ThemeMode.system;
    this.languageId = languageId ?? 'en';
  }

  Setting copyAll() {
    return Setting(
      themeMode: themeMode,
      languageId: languageId,
    );
  }
}
