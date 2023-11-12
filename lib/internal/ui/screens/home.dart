import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:villagerio/internal/data/enum/mode.dart';
import 'package:villagerio/internal/data/model/session.dart';
import 'package:villagerio/internal/pkg/logger/logger.dart';
import 'package:villagerio/internal/services/joiner.dart';
import 'package:villagerio/internal/services/language.dart';
import 'package:villagerio/internal/services/room_registration.dart';
import 'package:villagerio/internal/services/theme.dart';
import 'package:villagerio/internal/ui/modules/fullscreen_loading.dart';
import 'package:villagerio/internal/ui/modules/join_modal.dart';
import 'package:villagerio/internal/ui/modules/simple_router.dart';
import 'package:villagerio/internal/ui/modules/wrapper.dart';
import 'package:villagerio/internal/ui/screens/guide.dart';
import 'package:villagerio/internal/ui/screens/setting.dart';
import 'package:villagerio/internal/ui/screens/stats.dart';
import 'package:villagerio/internal/ui/screens/waiting_room.dart';

final _log = InternalLogger.instance;

class HomePage extends StatelessWidget {
  final Session session;

  const HomePage({super.key, required this.session});

  Widget _packageInfo() {
    return FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: ((context, snapshot) {
          String buildNumber = "x", version = "x";
          if (snapshot.hasData) {
            buildNumber = snapshot.data!.buildNumber;
            version = snapshot.data!.version;
          }

          return Text(
            "v$version ($buildNumber)",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Theme.of(context).disabledColor),
          );
        }));
  }

  void _joinDialog(
      BuildContext context, Widget Function(Session session) builder) {
    _log.d("Session => ${session.toString()}");
    showDialog(
        context: context,
        builder: (_) => JoinModal(
              session: session,
            )).then((value) {
      _log.d("Join State => $value");
      if (value == JoinerState.success) {
        final playableSession = session.copyWith();
        session.withValue(unsetRoom: true);
        SimpleRouter(context).push(() => builder(playableSession));
      }
    });
  }

  Widget _menuOptions(BuildContext context) {
    final str = LanguageService.str(context);
    final router = SimpleRouter(context);

    final menus = [
      MaterialButton(
          minWidth: double.infinity,
          onPressed: () => _joinDialog(
              context, (session) => WaitingRoomPage(session: session)),
          child: Text(str.join)),
      MaterialButton(
          minWidth: double.infinity,
          onPressed: () {
            router.push(() => FullScreenLoading(
                  withCancel: (_) async {
                    return false;
                  },
                  hideAppBar: true,
                  subtitle: "${str.creatingNewVillage}...",
                  onBuild: (context) async {
                    final router = SimpleRouter(context);
                    try {
                      final room = await RoomRegistrationService.createNewRoom(
                          session.user!);
                      router.pushReplacement(() => WaitingRoomPage(
                          session: session.copyWith(room: room)));
                    } catch (e) {
                      router.pop();
                    }
                  },
                ));
          },
          child: Text(str.createNewVillage)),
      MaterialButton(
          minWidth: double.infinity,
          onPressed: () =>
              _joinDialog(context, (session) => StatsScreen(session: session)),
          child: Text(
            str.statsMode,
          )),
      MaterialButton(
          minWidth: double.infinity,
          onPressed: () => router.push(() => const GuidePage()),
          child: Text(str.guide)),
      MaterialButton(
          minWidth: double.infinity,
          onPressed: () {
            router.push(() => SettingPage(
                  session: session,
                ));
          },
          child: Text(str.settings))
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: menus
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: e,
              ))
          .toList(growable: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeService.of(context).updateHeaderColor(context);
    final str = LanguageService.str(context);
    if (session.room != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _log.d("Using building join dialog");
        _joinDialog(context, (session) {
          _log.i(session.mode);
          switch (session.mode) {
            case Mode.userMode:
              return WaitingRoomPage(session: session);
            default:
              return StatsScreen(session: session);
          }
        });
      });
    }

    final isCompact = MediaQuery.of(context).size.height.toInt() < 420;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.50), BlendMode.dstATop),
                      fit: BoxFit.cover,
                      image: const AssetImage("assets/wallpaper/main.jpg"))),
            ),
            Wrapper.wrapInScrollView(
              wrap: isCompact,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrapper.wrapInExpanded(
                        unexpandedMaxHeight: 200,
                        child: SizedBox(),
                        wrap: !isCompact),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        children: [
                          Text(str.villagerio,
                              style: Theme.of(context).textTheme.displayMedium),
                          Text(
                            str.tagline,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  fontSize: 16,
                                ),
                          ),
                          _packageInfo(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: SizedBox(width: 200, child: _menuOptions(context)),
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
