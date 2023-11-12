import 'package:flutter/material.dart';
import 'package:villagerio/internal/data/model/session.dart';
import 'package:villagerio/internal/services/language.dart';
import 'package:villagerio/internal/ui/modules/simple_router.dart';
import 'package:villagerio/internal/ui/screens/guide.dart';
import 'package:villagerio/internal/ui/screens/setting.dart';
import 'package:villagerio/internal/ui/screens/share.dart';

class PopupMenuModal extends StatelessWidget {
  final Session session;
  final BuildContext context;
  const PopupMenuModal(
      {super.key, required this.session, required this.context});

  @override
  Widget build(BuildContext context) {
    final str = LanguageService.str(context);
    return PopupMenuButton(
        position: PopupMenuPosition.under,
        onSelected: (screen) => SimpleRouter(context).push(() => screen),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: const GuidePage(),
              child: Text(str.guide),
            ),
            PopupMenuItem(
              value: SharePage(
                session: session,
              ),
              child: Text(str.share),
            ),
            PopupMenuItem(
              value: SettingPage(session: session),
              child: Text(str.settings),
            )
          ];
        });
  }
}
