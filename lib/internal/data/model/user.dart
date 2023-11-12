import 'package:flutter/material.dart';

class User {
  final String id;
  late String? name;
  late String emoji;
  late Color color;
  String get idShort => id.length > 8 ? id.substring(0, 8) : id;

  User({required this.id, this.name, String? emoji, Color? color}) {
    this.emoji = emoji ?? "😄";
    this.color = color ?? Colors.blue;
  }

  void withValueFrom(User user) {
    name = user.name;
    emoji = user.emoji;
    color = user.color;
  }

  @override
  bool operator ==(Object other) {
    return id == (other as User).id;
  }

  // ignore: unnecessary_overrides
  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return '{"id":$id,"name":"$name","emoji":"$emoji","color":"$color"}';
  }
}
