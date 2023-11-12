import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class InternalLogger extends Logger {
  static final instance = Logger(
    level: kDebugMode ? Level.debug : Level.error,
    printer: PrettyPrinter(
      lineLength: 125,
      methodCount: 1,
    ),
  );
}
