import 'package:flutter/material.dart';
import 'package:villagerio/internal/data/model/session.dart';
import 'package:villagerio/internal/services/language.dart';

class StatsScreen extends StatelessWidget {
  final Session session;
  const StatsScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final str = LanguageService.str(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(str.statsMode),
      ),
    );
  }
}
