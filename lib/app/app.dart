import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:villagerio/internal/data/model/room.dart';
import 'package:villagerio/internal/data/model/session.dart';
import 'package:villagerio/internal/data/model/setting.dart';
import 'package:villagerio/internal/data/model/user.dart';
import 'package:villagerio/internal/services/auth.dart';
import 'package:villagerio/internal/services/theme.dart';
import 'package:villagerio/internal/services/language.dart';
import 'package:villagerio/internal/services/window.dart';
import 'package:villagerio/internal/ui/modules/fullscreen_loading.dart';
import 'package:villagerio/internal/ui/modules/fullscreen_message.dart';
import 'package:villagerio/internal/ui/screens/guide.dart';
import 'package:villagerio/internal/ui/screens/home.dart';
import 'package:villagerio/internal/ui/screens/waiting_room.dart';

// ignore: must_be_immutable
class App extends StatelessWidget {
  final _session = Session(
    mode: WindowService.getMode(),
    room: WindowService.getRoom(),
  );

  final AuthService _authSvc = AuthService();

  late Setting _setting;
  App({super.key, Setting? setting}) {
    _setting = setting ?? Setting();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance
        .addPostFrameCallback((_) => FlutterNativeSplash.remove());
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) {
            return LanguageService(_setting.languageId);
          }),
          BlocProvider(create: (_) => ThemeService(_setting.themeMode)),
        ],
        child: BlocBuilder<LanguageService, String>(builder: (context, lang) {
          final themeSvc = ThemeService.of(context);
          return MaterialApp(
              initialRoute: "/",
              title: 'Villagerio',
              locale: LanguageService.getLocaleById(lang),
              localizationsDelegates: LanguageService.localizationsDelegates,
              supportedLocales: LanguageService.supportedLocales,
              darkTheme: themeSvc.darkTheme,
              themeMode: ThemeMode.dark,
              home: FutureBuilder(
                  future: _authSvc.authenticate(),
                  builder: (context, ss) {
                    if (ss.hasError || (ss.hasData && ss.data == null)) {
                      return FullScreenMessage(
                          text:
                              LanguageService.str(context).errorPleaseRestart);
                    } else if (ss.hasData && ss.data != null) {
                      // return GuidePage();
                      return HomePage(
                        session: _session.withValue(
                          user: ss.data,
                        ),
                      );
                      final user = User(id: "host");
                      return WaitingRoomPage(
                          session: _session.withValue(
                              user: user,
                              room: Room(
                                id: 1234,
                                host: user,
                              )));
                    } else {
                      return const FullScreenLoading();
                    }
                  }),
              debugShowCheckedModeBanner: false);
        }));
  }
}
