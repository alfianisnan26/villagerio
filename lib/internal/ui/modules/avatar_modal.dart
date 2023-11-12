import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:villagerio/internal/data/model/session.dart';
import 'package:villagerio/internal/pkg/logger/logger.dart';
import 'package:villagerio/internal/services/language.dart';
import 'package:villagerio/internal/ui/modules/simple_router.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

final _log = InternalLogger.instance;

class AvatarModal extends StatefulWidget {
  final Session session;
  const AvatarModal({super.key, required this.session});
  @override
  State<AvatarModal> createState() => _AvatarModalState();
}

class _AvatarModalState extends State<AvatarModal>
    with TickerProviderStateMixin {
  late TabController _tc;
  int _tabIndex = 0;

  @override
  void initState() {
    _tc = TabController(length: 2, vsync: this);
    _tc.addListener(() {
      setState(() {
        _tabIndex = _tc.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _log.d("Running avatar Modal");
    final str = LanguageService.str(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => SimpleRouter(context).pop(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 15),
                child: Hero(
                    tag: "avatar",
                    child: CircleAvatar(
                        backgroundColor: widget.session.user!.color,
                        radius: 90,
                        child: Text(widget.session.user!.emoji,
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .fontSize! +
                                    20)))),
              ),
              Dialog(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 185),
                        child: TabBarView(controller: _tc, children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: MaterialColorPicker(
                                  onlyShadeSelection: true,
                                  selectedColor: widget.session.user!.color,
                                  onColorChange: (val) {
                                    setState(() {
                                      widget.session.user!.color = val;
                                    });
                                  },
                                ),
                              )),
                          Align(
                            alignment: Alignment.topCenter,
                            child: EmojiPicker(
                              config: const Config(bgColor: Colors.transparent),
                              onEmojiSelected: (cat, val) => setState(() {
                                widget.session.user!.emoji = val.emoji;
                              }),
                            ),
                          ),
                        ]),
                      ),
                      BottomNavigationBar(
                        currentIndex: _tabIndex,
                        onTap: (val) => setState(() {
                          _tc.animateTo(val);
                        }),
                        items: [
                          BottomNavigationBarItem(
                              label: str.color,
                              icon: const Icon(Icons.colorize)),
                          BottomNavigationBarItem(
                              label: str.icon, icon: const Icon(Icons.face))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
