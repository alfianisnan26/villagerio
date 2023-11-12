import 'package:flutter/material.dart';
import 'package:villagerio/internal/ui/modules/hero_dialog_route.dart';

class SimpleRouter {
  final BuildContext context;
  SimpleRouter(this.context);

  void pop<T extends Object?>([T? result]) {
    return Navigator.pop<T>(context, result);
  }

  Future<T?> push<T extends Object?>(Widget Function() builder) {
    return Navigator.push(
        context, MaterialPageRoute(builder: (_) => builder()));
  }

  Future<T?> heroDialog<T extends Object?>(Widget Function() builder) {
    return Navigator.push(context, HeroDialogRoute(builder: (_) => builder()));
  }

  Future<T?> pushReplacement<T extends Object?>(Widget Function() builder) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => builder()));
  }
}
