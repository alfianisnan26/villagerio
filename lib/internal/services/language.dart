import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/lang.dart';
import 'package:flutter_gen/gen_l10n/lang_en.dart';
import 'package:villagerio/internal/pkg/logger/logger.dart';

final _log = InternalLogger.instance;

class LanguageService extends Cubit<String> {
  LanguageService(String initState) : super(initState);

  Future<bool> setLanguageById(String val) async {
    final lang = supportedLocales.firstWhere(
        (element) => element.toLanguageTag() == val,
        orElse: () => supportedLocales.first);

    _log.d("Set language tp ${lang.toLanguageTag()} with param value $val");
    emit(lang.toLanguageTag());
    return lang.toLanguageTag() != state;
  }

  static AppLang str(BuildContext context) =>
      AppLang.of(context) ?? AppLangEn();

  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      AppLang.localizationsDelegates;
  static List<Locale> get supportedLocales => AppLang.supportedLocales;

  factory LanguageService.of(BuildContext context) {
    return context.read<LanguageService>();
  }

  static getLocaleById(String val) {
    return supportedLocales.firstWhere(
        (element) => element.toLanguageTag() == val,
        orElse: () => supportedLocales.first);
  }
}
