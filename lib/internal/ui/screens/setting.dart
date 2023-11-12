import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:villagerio/internal/data/model/session.dart';
import 'package:villagerio/internal/pkg/logger/logger.dart';
import 'package:villagerio/internal/services/language.dart';
import 'package:villagerio/internal/services/setting.dart';
import 'package:villagerio/internal/services/window.dart';
import 'package:villagerio/internal/ui/modules/simple_router.dart';
import 'package:villagerio/internal/ui/modules/snackbar.dart';

final _log = InternalLogger.instance;

class SettingPage extends StatelessWidget {
  final Session session;
  const SettingPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final str = LanguageService.str(context);
    final userId = (session.user != null) ? session.user!.id : str.error;
    return BlocProvider(
      create: (BuildContext context) => SettingService(context),
      child: BlocBuilder<SettingService, bool>(builder: (context, state) {
        final settingSvc = SettingService.of(context);
        return WillPopScope(
          onWillPop: () async {
            if (SettingService.of(context).state) {
              InternalSnackBar.show(
                context,
                str.alertNotSaved,
                action: SnackBarAction(
                    label: str.yes,
                    onPressed: () {
                      SettingService.of(context).reset(context);
                    }),
                duration: const Duration(seconds: 10),
                onClose: (reason) {
                  _log.d("Scaffold pop reason on close => $reason");
                  switch (reason) {
                    case SnackBarClosedReason.action:
                      SimpleRouter(context).pop();
                    default:
                  }
                },
              );
              return false;
            }

            return true;
          },
          child: Scaffold(
              appBar: AppBar(title: Text(str.settings), actions: [
                IconButton(
                    onPressed: state
                        ? () => SettingService.of(context).save().then(
                            (value) => InternalSnackBar.pop(context,
                                reason: SnackBarClosedReason.action))
                        : null,
                    icon: const Icon(Icons.save))
              ]),
              body: ListView(
                children: [
                  // Theme mode deprecated
                  // SmartSelect.single(
                  //     title: str.themeMode,
                  //     selectedValue: settingSvc.setting.themeMode,
                  //     choiceItems: [
                  //       S2Choice(value: ThemeMode.system, title: str.system),
                  //       S2Choice(value: ThemeMode.light, title: str.light),
                  //       S2Choice(value: ThemeMode.dark, title: str.dark),
                  //     ],
                  //     onChange: (selected) {
                  //       settingSvc.set(context, themeMode: selected.value);
                  //     },
                  //     modalType: S2ModalType.bottomSheet,
                  //     tileBuilder: (context, state) {
                  //       return S2Tile.fromState(state);
                  //     }),

                  SmartSelect.single(
                    title: str.language,
                    selectedValue: settingSvc.setting.languageId,
                    choiceItems: [
                      S2Choice(value: 'id', title: str.indonesia),
                      S2Choice(value: 'en', title: str.english)
                    ],
                    onChange: (selected) {
                      settingSvc.set(context, languageId: selected.value);
                    },
                    modalType: S2ModalType.bottomSheet,
                    tileBuilder: (context, state) {
                      return S2Tile.fromState(state);
                    },
                  ),
                  ListTile(
                    title: Text(str.requestForFullscreen),
                    onTap: () {
                      WindowService.requestFullScreen();
                    },
                  ),
                  ListTile(
                    enabled: false,
                    title: Text(str.userId),
                    trailing: Text(userId),
                  ),
                ],
              )),
        );
      }),
    );
  }
}
