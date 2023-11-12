import 'package:flutter/material.dart';
import 'package:villagerio/internal/data/model/prefs.dart';

class ThemeModePrefs extends Prefs<String> {
  ThemeModePrefs(ThemeMode defaultValue)
      : super((ThemeModePrefs).toString(), defaultValue.name);
}

class LanguagePrefs extends Prefs<String> {
  LanguagePrefs(String defaultValue)
      : super((LanguagePrefs).toString(), defaultValue);
}
