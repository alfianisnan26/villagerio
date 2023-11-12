import 'package:flutter/material.dart';

class InternalSnackBar extends SnackBar {
  static bool _isActiveSnackbar = false;
  static bool get isActiveSnackBar => _isActiveSnackbar;
  const InternalSnackBar({
    super.key,
    required super.content,
    super.duration,
    super.action,
  });

  void show(BuildContext context, {Function(SnackBarClosedReason)? onClose}) {
    pop(context);
    _isActiveSnackbar = true;
    final sb = ScaffoldMessenger.of(context).showSnackBar(this);
    sb.closed.then((value) {
      _isActiveSnackbar = false;
      if (onClose != null) {
        return onClose(value);
      }
    });
  }

  factory InternalSnackBar.show(BuildContext context, String text,
      {Widget Function(String)? contentBuilder,
      SnackBarAction? action,
      Function(SnackBarClosedReason)? onClose,
      Duration duration = const Duration(seconds: 2)}) {
    final snackBar = InternalSnackBar(
      action: action,
      content: contentBuilder != null
          ? contentBuilder(text)
          : GestureDetector(
              onTap: () {
                pop(context);
              },
              child: Text(text),
            ),
      duration: duration,
    );

    snackBar.show(context, onClose: onClose);
    return snackBar;
  }

  static hasAnotherSnackBar() {}

  static pop(BuildContext context,
      {SnackBarClosedReason reason = SnackBarClosedReason.dismiss}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(reason: reason);
  }
}
