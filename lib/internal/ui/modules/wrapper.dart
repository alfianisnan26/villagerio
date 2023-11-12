import 'package:flutter/material.dart';

class Wrapper {
  static Widget wrapInScrollView({required Widget child, bool wrap = false}) {
    return wrap
        ? SingleChildScrollView(
            child: child,
          )
        : child;
  }

  static Widget wrapInMaxBoxConstrained(
      {required Widget child,
      bool wrap = false,
      double maxHeight = double.infinity,
      double maxWidth = double.infinity}) {
    return wrap
        ? ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
            child: child,
          )
        : child;
  }

  static Widget wrapInExpanded(
      {required Widget child,
      bool wrap = false,
      double? unexpandedMaxHeight,
      double? unexpandedMaxWidth}) {
    return wrap
        ? Expanded(
            child: child,
          )
        : wrapInMaxBoxConstrained(
            child: child,
            wrap: unexpandedMaxHeight != null || unexpandedMaxWidth != null,
            maxHeight: unexpandedMaxHeight ?? double.infinity,
            maxWidth: unexpandedMaxWidth ?? double.infinity);
  }

  static List<T> wrapListWidgetAppendIf<T>(
      {required List<T> children,
      required T child,
      bool append = false,
      bool first = false}) {
    if (!append) return children;

    final newList = List<T>.from(children);
    if (first) {
      final firstList = [child];
      firstList.addAll(newList);
      return firstList;
    }

    newList.add(child);
    return newList;
  }

  static Widget injectKey(Key key, Widget widget) {
    return _NothingWidget(
      widget: widget,
      key: key,
    );
  }
}

class _NothingWidget extends StatelessWidget {
  final Widget widget;
  const _NothingWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}
