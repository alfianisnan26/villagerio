import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:villagerio/internal/data/enum/std_state.dart';
import 'package:villagerio/internal/data/model/room.dart';
import 'package:villagerio/internal/data/model/session.dart';
import 'package:villagerio/internal/pkg/logger/logger.dart';
import 'package:villagerio/internal/services/joiner.dart';
import 'package:villagerio/internal/services/language.dart';
import 'package:villagerio/internal/services/window.dart';
import 'package:villagerio/internal/ui/modules/simple_router.dart';
import 'package:villagerio/internal/ui/modules/snackbar.dart';

final _log = InternalLogger.instance;

class JoinModal extends StatefulWidget {
  final Session session;
  const JoinModal({super.key, required this.session});

  @override
  State<JoinModal> createState() => _JoinModalState();
}

class _JoinModalState extends State<JoinModal> {
  late TextEditingController _tec;
  bool _joinBtnState = false;
  StdState _qrState = StdState.idle;
  late FocusNode _fnTextField;

  @override
  void initState() {
    _fnTextField = FocusNode();
    String? initValue;
    if (widget.session.room != null) {
      initValue = widget.session.room!.id.toString();
      if (initValue.length != 4) {
        initValue = null;
        widget.session.withValue(unsetRoom: true);
      }
    }
    _tec = TextEditingController(text: initValue);
    super.initState();
  }

  @override
  void dispose() {
    _fnTextField.dispose();
    _tec.dispose();
    super.dispose();
  }

  void _join(BuildContext context) {
    _joinBtnState = true;
    _qrState = StdState.idle;
    final roomId = int.tryParse(_tec.text);
    if (roomId != null) {
      JoinerService.of(context).join(roomId).then((value) {
        if (value == JoinerState.success) {
          widget.session.withValue(room: Room(id: roomId));
          SimpleRouter(context).pop(value);
        } else if (value == JoinerState.error) {
          InternalSnackBar.show(context,
              "cannot join right now, please check the roomId and try again later");
        }
      });
    }
  }

  Widget _showQr(BuildContext context) {
    final str = LanguageService.str(context);
    return AspectRatio(
      aspectRatio: 1,
      child: Center(child: Text(str.comingSoon)),
    );
  }

  void _onCancel(BuildContext context) {
    InternalSnackBar.pop(context);
    SimpleRouter(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final str = LanguageService.str(context);
    return ScaffoldMessenger(child: Builder(builder: (context) {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocProvider(
              create: (BuildContext context) => JoinerService(),
              child: BlocBuilder<JoinerService, JoinerState>(
                  builder: (context, state) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (widget.session.room != null) {
                    _join(context);
                    widget.session.withValue(unsetRoom: true);
                  }

                  if (state == JoinerState.error) {
                    JoinerService.of(context).setIdle();
                    _fnTextField.requestFocus();
                  }
                });
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: state == JoinerState.joining
                          ? null
                          : () => _onCancel(context),
                    ),
                    AlertDialog(
                      title: Text(
                        str.join,
                        textAlign: TextAlign.center,
                      ),
                      content: _qrState == StdState.success
                          ? _showQr(context)
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  str.pleaseProvideRoomIdToJoin,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                TextFormField(
                                    focusNode: _fnTextField,
                                    autocorrect: false,
                                    enabled: state != JoinerState.joining,
                                    onChanged: (value) {
                                      if (value.length == 4) {
                                        _join(context);
                                      } else if (_joinBtnState &&
                                          value.length < 4) {
                                        setState(() {
                                          _joinBtnState = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: "XXXX",
                                      hintStyle: TextStyle(
                                          color:
                                              Theme.of(context).disabledColor),
                                      icon: const Icon(Icons.numbers),
                                    ),
                                    autofocus: true,
                                    controller: _tec,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                    maxLength: 4,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ])
                              ],
                            ),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        TextButton(
                            onPressed: () => _onCancel(context),
                            child: Text(str.cancel)),
                        IconButton(
                            onPressed: _qrState == StdState.loading
                                ? null
                                : () async {
                                    _log.d("Clicking switcher");
                                    InternalSnackBar.pop(context);
                                    if (_qrState == StdState.success) {
                                      setState(() {
                                        _qrState = StdState.idle;
                                        _fnTextField.requestFocus();
                                      });
                                    } else {
                                      setState(() {
                                        _qrState = StdState.loading;
                                      });

                                      final isPermitted = await WindowService
                                          .checkCameraPermission();

                                      setState(() {
                                        if (isPermitted) {
                                          _qrState = StdState.success;
                                        } else {
                                          InternalSnackBar.show(context,
                                              str.errorCameraIsNotAllowed);

                                          _qrState = StdState.failed;
                                        }
                                      });
                                    }
                                  },
                            icon: _qrState == StdState.loading
                                ? const CircularProgressIndicator()
                                : Icon(_qrState == StdState.success
                                    ? Icons.numbers
                                    : Icons.qr_code_scanner)),
                        Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Visibility(
                                visible: state == JoinerState.joining,
                                child: const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              Visibility(
                                maintainAnimation: true,
                                maintainSize: true,
                                maintainState: true,
                                visible: state != JoinerState.joining,
                                child: TextButton(
                                    onPressed: _joinBtnState
                                        ? () => _join(context)
                                        : null,
                                    child: Text(str.join)),
                              ),
                            ])
                      ],
                    ),
                  ],
                );
              })));
    }));
  }
}
