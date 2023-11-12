import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:villagerio/internal/pkg/logger/logger.dart';
import 'package:villagerio/internal/services/window.dart';

final _log = InternalLogger.instance;

class ThemeService extends Cubit<ThemeMode> {
  static final stdTextStyle = GoogleFonts.mynerve();

  ThemeService(super.initialState);

  Future<bool> setThemeModeByName(String value) {
    var mode = state;
    if (value == ThemeMode.system.name) {
      mode = ThemeMode.system;
    } else if (value == ThemeMode.light.name) {
      mode = ThemeMode.light;
    } else if (value == ThemeMode.dark.name) {
      mode = ThemeMode.dark;
    }

    return setThemeMode(mode);
  }

  Future<bool> setThemeMode(ThemeMode mode) async {
    emit(mode);
    return mode != state;
  }

  bool get isDarkMode => state == ThemeMode.dark;

  ThemeData _setFontFamily(ThemeData parent, TextStyle style) {
    String fontFamily = style.fontFamily!;
    final tt = parent.textTheme;

    return parent.copyWith(
        textTheme: tt.copyWith(
      displayLarge: tt.displayLarge!.copyWith(fontFamily: fontFamily),
      displayMedium: tt.displayMedium!
          .copyWith(fontFamily: fontFamily, fontWeight: FontWeight.bold),
      displaySmall: tt.displaySmall!.copyWith(fontFamily: fontFamily),
      headlineLarge: tt.headlineLarge!.copyWith(fontFamily: fontFamily),
      headlineMedium: tt.headlineMedium!.copyWith(fontFamily: fontFamily),
      headlineSmall: tt.headlineSmall!.copyWith(fontFamily: fontFamily),
      titleLarge: tt.titleLarge!.copyWith(fontFamily: fontFamily),
      titleMedium: tt.titleMedium!.copyWith(fontFamily: fontFamily),
      titleSmall: tt.titleSmall!.copyWith(fontFamily: fontFamily),
      bodyLarge: tt.bodyLarge!.copyWith(fontFamily: fontFamily),
      bodyMedium: tt.bodyMedium!.copyWith(fontFamily: fontFamily),
      bodySmall: tt.bodySmall!.copyWith(fontFamily: fontFamily),
      labelLarge: tt.labelLarge!.copyWith(fontFamily: fontFamily),
      labelMedium: tt.labelMedium!.copyWith(fontFamily: fontFamily),
      labelSmall: tt.labelSmall!.copyWith(fontFamily: fontFamily),
    ));
  }

  ThemeData get darkTheme {
    return _setFontFamily(ThemeData.dark(), stdTextStyle);
  }

  ThemeData get lightTheme {
    return _setFontFamily(ThemeData.light(), stdTextStyle);
  }

  factory ThemeService.of(BuildContext context) {
    return context.read<ThemeService>();
  }

  void updateHeaderColor(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var color = Theme.of(context).colorScheme.background;
      WindowService.setMetaThemeColor(color);
    });
  }
}
