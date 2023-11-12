import 'package:firebase_auth/firebase_auth.dart';
import 'package:villagerio/internal/pkg/logger/logger.dart';
import 'package:villagerio/internal/data/model/user.dart' as internalUser;

final _log = InternalLogger.instance;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<internalUser.User?> authenticate() async {
    final data = await _auth.signInAnonymously();
    if (data.user == null) {
      return null;
    }

    return internalUser.User(id: data.user!.uid);
  }
}
