import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:villagerio/internal/data/model/setting.dart';
import 'package:villagerio/internal/pkg/logger/logger.dart';
import 'package:villagerio/internal/pkg/prefs/prefs.dart';
import 'package:villagerio/internal/services/language.dart';
import 'package:villagerio/internal/services/theme.dart';
import 'package:villagerio/internal/services/window.dart';

final _log = InternalLogger.instance;

class SettingService extends Cubit<bool> {
  late Setting _existing;
  late Setting _current;

  bool isChanged() {
    return _existing.languageId != _current.languageId ||
        _existing.themeMode != _current.themeMode;
  }

  Setting get setting => _current;

  SettingService(BuildContext context) : super(false) {
    _existing = Setting(
      themeMode: ThemeService.of(context).state,
      languageId: LanguageService.of(context).state,
    );
    _current = _existing.copyAll();
  }

  void set(BuildContext context, {ThemeMode? themeMode, String? languageId}) {
    if (themeMode != null) {
      ThemeService.of(context).setThemeMode(themeMode);
      _current.themeMode = themeMode;
    }

    if (languageId != null) {
      LanguageService.of(context).setLanguageById(languageId);
      _current.languageId = languageId;
    }

    emit(isChanged());
  }

  factory SettingService.of(BuildContext context) {
    return context.read<SettingService>();
  }

  Future<void> save() async {
    if (_existing.languageId != setting.languageId) {
      await LanguagePrefs(_existing.languageId).set(setting.languageId);
    }
    if (_existing.themeMode != setting.themeMode) {
      await ThemeModePrefs(_existing.themeMode).set(setting.themeMode.name);
    }

    emit(false);
    _existing = _current.copyAll();
  }

  Future<void> reset(BuildContext context) async {
    final langSvc = LanguageService.of(context);
    final themeSvc = ThemeService.of(context);
    if (_existing.languageId != setting.languageId) {
      await langSvc.setLanguageById(_existing.languageId);
    }
    if (_existing.themeMode != setting.themeMode) {
      await themeSvc.setThemeMode(_existing.themeMode);
    }
  }

  static Future<Setting> load() async {
    final themeMode = await ThemeModePrefs(ThemeMode.system).get();
    final languageId = await LanguagePrefs(
      LanguageService.supportedLocales
          .firstWhere(
              (element) =>
                  element.toLanguageTag() ==
                  WindowService.getWindowLocaleName(),
              orElse: () => const Locale('en'))
          .toLanguageTag(),
    ).get();
    final setting = Setting(
      languageId: languageId,
      themeMode:
          ThemeMode.values.firstWhere((element) => element.name == themeMode),
    );

    _log.d("init themeMode  => $themeMode");
    _log.d("init languageId => ${setting.languageId}");

    return setting;
  }
}
