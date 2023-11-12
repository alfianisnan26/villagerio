import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FullScreenLoading extends StatelessWidget {
  final String? subtitle;
  final void Function(BuildContext)? onBuild;
  final bool hideAppBar;
  final Future<bool> Function(BuildContext)? withCancel;
  const FullScreenLoading(
      {super.key,
      this.subtitle,
      this.onBuild,
      this.withCancel,
      this.hideAppBar = false});

  @override
  Widget build(BuildContext context) {
    if (onBuild != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) => onBuild!(context));
    }

    final List<Widget> children = [
      const CircularProgressIndicator(),
    ];

    if (subtitle != null) {
      children.add(const SizedBox(
        height: 25,
      ));
      children.add(Text(subtitle!));
    }

    AppBar? appBar;

    if (withCancel != null && !hideAppBar) {
      appBar = AppBar();
    }

    return WillPopScope(
      onWillPop: () async {
        if (withCancel == null) return true;
        return await withCancel!(context);
      },
      child: Scaffold(
          appBar: appBar,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: children,
            ),
          )),
    );
  }
}
