import 'dart:math';

import 'package:flutter/material.dart';
import 'package:villagerio/internal/ui/modules/wrapper.dart';

class Animator {
  static Widget _flipTransitionBuilder(
      Widget widget, Animation<double> animation, bool showFrontSide) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(showFrontSide) != widget!.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }

  static Widget flipper(
      {required Widget front,
      required Widget back,
      required bool showFrontSide,
      Duration duration = const Duration(milliseconds: 500)}) {
    return AnimatedSwitcher(
        duration: duration,
        transitionBuilder: (w, a) =>
            _flipTransitionBuilder(w, a, showFrontSide),
        layoutBuilder: (widget, list) => Stack(
              children: [widget!, ...list],
            ),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
        child: showFrontSide
            ? Wrapper.injectKey(const ValueKey(true), front)
            : Wrapper.injectKey(const ValueKey(false), back));
  }
}
