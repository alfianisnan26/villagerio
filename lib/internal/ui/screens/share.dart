import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:villagerio/internal/data/model/session.dart';
import 'package:villagerio/internal/services/joiner.dart';
import 'package:villagerio/internal/services/language.dart';
import 'package:villagerio/internal/ui/modules/animator.dart';
import 'package:villagerio/internal/ui/modules/snackbar.dart';
import 'package:villagerio/internal/ui/modules/wrapper.dart';

class SharePage extends StatefulWidget {
  final BuildContext? parentContext;
  final Session session;
  const SharePage({super.key, this.parentContext, required this.session});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  bool _isBlack = true;

  @override
  void initState() {
    super.initState();
  }

  Widget buildQRView(bool isActive, bool isFront) {
    final str = LanguageService.str(context);
    final url = JoinerService.constructJoinUrl(widget.session);

    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onLongPress: isActive
          ? () {
              setState(() {
                _isBlack = !_isBlack;
              });
            }
          : null,
      onPressed: isActive
          ? () => FlutterClipboard.copy(url).then(
              (value) => InternalSnackBar.show(context, str.sharingLinkCopied))
          : null,
      color: isFront ? Colors.white : Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: QrImageView(
            dataModuleStyle: QrDataModuleStyle(
              color: isFront ? Colors.black : Colors.white,
              dataModuleShape: QrDataModuleShape.square,
            ),
            eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: isFront ? Colors.black : Colors.white),
            data: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final str = LanguageService.str(context);
    var compactWidth = 770;
    if (widget.parentContext != null) {
      compactWidth += 50;
    }
    var isCompact = MediaQuery.of(context).size.height < compactWidth;
    final host = widget.session.room!.host!;
    return Scaffold(
        appBar: widget.parentContext == null
            ? AppBar(
                title: Text(str.share),
              )
            : null,
        body: Wrapper.wrapInScrollView(
            wrap: isCompact,
            child: Padding(
                padding: const EdgeInsets.all(50),
                child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                      Column(
                        children: [
                          Text(
                            str.roomId,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.session.room!.id.toString(),
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Tooltip(
                        waitDuration: const Duration(milliseconds: 1500),
                        message: str.longPressToFlip,
                        child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxHeight: 500, maxWidth: 500),
                            child: Animator.flipper(
                                front: buildQRView(_isBlack, true),
                                back: buildQRView(!_isBlack, false),
                                showFrontSide: _isBlack)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  child: Text(host.emoji,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(color: Colors.white)),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(str.host),
                                    Text(
                                      host.name ?? host.idShort.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                    Visibility(
                                        visible: host.name != null,
                                        child: Text(host.idShort))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ])))));
  }
}
