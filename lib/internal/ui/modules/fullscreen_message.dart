import 'package:flutter/material.dart';

class FullScreenMessage extends StatelessWidget {
  final String text;
  const FullScreenMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text),
      ),
    );
  }
}
