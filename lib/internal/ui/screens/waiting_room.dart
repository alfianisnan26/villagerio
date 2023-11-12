import 'dart:async';

import 'package:flutter/material.dart';
import 'package:villagerio/internal/data/model/session.dart';
import 'package:villagerio/internal/data/model/user.dart';
import 'package:villagerio/internal/pkg/logger/logger.dart';
import 'package:villagerio/internal/services/language.dart';
import 'package:villagerio/internal/ui/modules/avatar_modal.dart';
import 'package:villagerio/internal/ui/modules/popup_menu.dart';
import 'package:villagerio/internal/ui/modules/simple_router.dart';
import 'package:villagerio/internal/ui/modules/snackbar.dart';
import 'package:villagerio/internal/ui/modules/wrapper.dart';
import 'package:villagerio/internal/ui/screens/game_setting.dart';
import 'package:villagerio/internal/ui/screens/share.dart';

final _log = InternalLogger.instance;

class WaitingRoomPage extends StatefulWidget {
  final Session session;
  const WaitingRoomPage({super.key, required this.session});

  @override
  State<WaitingRoomPage> createState() => _WaitingRoomPageState();
}

Future<void> delay(int seconds) =>
    Future.delayed(Duration(milliseconds: seconds * 500));

class _WaitingRoomPageState extends State<WaitingRoomPage> {
  late StreamController<User> _streamController;
  final List<User> _users = [];

  Future<void> _loadStream(StreamController controller) async {
    controller.sink.add(widget.session.user);
    await delay(10);
    controller.sink.add(User(
        id: "uid-1",
        name: "First name of uid-1",
        emoji: "😚",
        color: Colors.red));
    await delay(1);
    controller.sink.add(User(
        id: "uid-2",
        name: "First name of uid-2",
        emoji: "🙏",
        color: Colors.blue));
    await delay(1);
    controller.sink.add(User(
        id: "uid-3",
        name: "First name of uid-3",
        emoji: "🏓",
        color: Colors.white));
    await delay(1);
    controller.sink.add(User(
        id: "uid-1",
        name: "Second name of uid-1",
        emoji: "🏄🏼‍♀️",
        color: Colors.green));
    await delay(1);
    controller.sink.add(User(
        id: "uid-3",
        name: "Second name of uid-3",
        emoji: "🥊",
        color: Colors.black));
    await delay(1);
    controller.sink.add(User(
        id: "uid-4",
        name: "First name of uid-4",
        emoji: "💽",
        color: Colors.yellow));
    await delay(1);
    controller.sink.add(User(
        id: "uid-2",
        name: "Second name of uid-2",
        emoji: "🪛",
        color: Colors.green));
    await delay(1);
    controller.sink.add(User(
      id: "uid-1",
    ));
    await delay(1);
    controller.sink.add(User(id: "uid-4", name: "Second name of uid-4"));
    await delay(1);
    controller.sink.add(User(id: "uid-5", name: "First name of uid-5"));
    await delay(1);
    controller.sink.add(User(
      id: "uid-2",
    ));
    await delay(1);
    controller.sink.add(User(id: "uid-1", name: "uid-1 renamed"));
    await delay(1);
    controller.sink.add(User(id: "uid-2", name: "user-2 renamed"));
    await delay(1);
    controller.sink.add(User(id: "uid-3", name: "user-3 renamed"));
    await delay(1);
    controller.sink.add(User(id: "uid-5", name: "user-5 renamed"));
    await delay(1);
    controller.sink.add(User(id: "uid-6", name: "uid-6"));
    await delay(1);
    controller.sink.add(User(id: "uid-7", name: "uid-7"));
    await delay(1);
    controller.sink.add(User(id: "uid-8", name: "uid-8"));
    await delay(1);
    controller.sink.add(User(id: "uid-9", name: "uid-9"));
    await delay(1);
    controller.sink.add(User(id: "uid-10", name: "uid-10"));
    await delay(1);
    controller.sink.add(User(id: "uid-1"));
    await delay(1);
    controller.sink.add(User(id: "uid-4"));
    await delay(1);
    controller.sink.add(User(id: "uid-7"));
    await delay(1);
    controller.sink.add(User(id: "uid-9", name: "uid-9 renamed"));
    await delay(1);
    controller.sink.add(User(id: "uid-10", name: "uid-10 renamed"));
    await delay(1);
    controller.sink.add(User(id: "uid-11", name: "has name of 11"));
    await delay(1);
    controller.sink.add(User(id: "uid-12", name: "has name of 12"));
    await delay(1);
    controller.sink.add(User(
        id: "uid-7", name: "rename for 7", emoji: "🍕", color: Colors.yellow));
    await delay(1);
    controller.sink.add(User(
        id: "uid-7",
        name: "rename again for 7",
        emoji: "🥦",
        color: Colors.green));
    await delay(1);
    controller.sink.add(User(id: "uid-11"));
    await delay(1);
    controller.sink.add(User(id: "uid-2"));
    await delay(1);
    controller.sink.add(User(
        id: "uid-15", name: "name for 15", emoji: "🌽", color: Colors.yellow));
    await delay(1);
    controller.sink.add(User(
        id: "uid-14", name: "name for 14", emoji: "🍈", color: Colors.white));
    await delay(1);
    controller.sink.add(User(
        id: "uid-17", name: "name for 17", emoji: "🥎", color: Colors.red));
    await delay(1);
    controller.sink.add(User(
        id: "uid-16", name: "name for 16", emoji: "❤️‍🔥", color: Colors.red));
    await delay(1);
    controller.sink.add(User(
        id: "uid-18", name: "name for 18", emoji: "💛", color: Colors.yellow));
  }

  @override
  void initState() {
    _streamController = StreamController.broadcast();
    _streamController.stream.listen((event) => setState(() {
          final obj = _users.where((element) => element == event);

          if (obj.isEmpty) {
            _users.add(event);
          } else {
            final existUser = obj.first;
            if (event.emoji.isEmpty) {
              _users.removeWhere((element) => element == event);
            } else {
              existUser.withValueFrom(event);
            }
          }
        }));
    super.initState();
    _loadStream(_streamController);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Widget _makeUserElement(BuildContext context, User user) {
    final str = LanguageService.str(context);
    final userIsHost = widget.session.room!.host == user;
    return ListTile(
      trailing: !widget.session.isHost() || userIsHost
          ? (userIsHost
              ? TextButton(onPressed: null, child: Text(str.host))
              : null)
          : TextButton(
              onPressed: () {
                InternalSnackBar.show(
                    context, str.longPressTo(str.kick.toLowerCase()));
              },
              onLongPress: () async {
                InternalSnackBar.show(
                  context,
                  str.userIs(
                    str.kick.toLowerCase(),
                    user.name ?? '(${user.idShort})',
                  ),
                  action: SnackBarAction(
                      label: str.block,
                      onPressed: () async {
                        InternalSnackBar.show(
                            context,
                            str.userIs(str.block.toLowerCase(),
                                user.name ?? '(${user.idShort})'));
                      }),
                );
                setState(() {
                  _users.remove(user);
                });
              },
              child: Text(str.kick),
            ),
      leading: CircleAvatar(
          backgroundColor: user.color,
          child: Text(
            user.emoji,
            style: TextStyle(
                fontSize:
                    Theme.of(context).textTheme.headlineSmall!.fontSize! - 5),
          )),
      title: Text(
        user.name ?? user.idShort,
        overflow: TextOverflow.fade,
      ),
      subtitle: Text(
        overflow: TextOverflow.fade,
        user.name == null ? "" : user.idShort,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: Theme.of(context)
                .textTheme
                .labelSmall!
                .color!
                .withOpacity(0.5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final str = LanguageService.str(context);
    var tabBars = [
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(str.players),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(25)),
              child: Text(
                _users.length.toString(),
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
      Tab(text: str.share)
    ];

    if (widget.session.isHost()) {
      final tabBarsHost = [Tab(text: str.gameSetting)];
      tabBarsHost.addAll(tabBars);
      tabBars = tabBarsHost;
    }

    return WillPopScope(
      onWillPop: () async {
        InternalSnackBar.show(
          context,
          str.alertQuitTheGame,
          action: SnackBarAction(
              label: str.quit,
              onPressed: () async {
                SimpleRouter(context).pop();
                // TODO: delete user session
              }),
        );
        return false;
      },
      child: DefaultTabController(
        length: widget.session.isHost() ? 3 : 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(str.waitingForGameToPlay),
            actions: [
              PopupMenuModal(
                context: context,
                session: widget.session,
              ),
            ],
            bottom: TabBar(
              tabs: tabBars,
            ),
          ),
          body: TabBarView(
            children: Wrapper.wrapListWidgetAppendIf(
                append: widget.session.isHost(),
                child: GameSettingPage(
                  session: widget.session,
                  parentContext: context,
                ),
                first: true,
                children: [
                  Column(mainAxisSize: MainAxisSize.max, children: [
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(30),
                          itemCount: _users.length,
                          itemBuilder: (context, index) =>
                              _makeUserElement(context, _users[index])),
                    ),
                    Material(
                        color: Theme.of(context).disabledColor,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: GestureDetector(
                                onTap: () {
                                  SimpleRouter(context)
                                      .heroDialog(() =>
                                          AvatarModal(session: widget.session))
                                      .then((value) => setState(() {}));
                                },
                                child: Hero(
                                    tag: "avatar",
                                    child: CircleAvatar(
                                        backgroundColor:
                                            widget.session.user!.color,
                                        radius: 50,
                                        child: Text(
                                          widget.session.user!.emoji,
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge!
                                                  .fontSize),
                                        ))),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(str.roomIdVar(widget.session.room ==
                                            null
                                        ? "n/a"
                                        : widget.session.room!.id.toString())),
                                    TextFormField(
                                        autofocus:
                                            widget.session.user!.name == "",
                                        maxLength: 20,
                                        decoration: InputDecoration(
                                            hintText: str.myNameIs,
                                            border: InputBorder.none,
                                            counterText: ""),
                                        initialValue: widget.session.user!.name,
                                        onChanged: (v) {
                                          setState(() {
                                            if (v == "") {
                                              widget.session.user!.name = null;
                                            } else {
                                              widget.session.user!.name = v;
                                            }
                                          });
                                        },
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                    Text(
                                      widget.session.user!.idShort,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .color!
                                                  .withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  ]),
                  SharePage(
                    session: widget.session,
                    parentContext: context,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
