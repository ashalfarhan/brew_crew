import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

class AuthService {
  final fire_auth.FirebaseAuth _auth = fire_auth.FirebaseAuth.instance;

  User? _userFromFireAuth(fire_auth.User? fireUser) {
    return fireUser != null ? User(uid: fireUser.uid) : null;
  }

  Stream<User?> get user {
    return fire_auth.FirebaseAuth.instance
        .authStateChanges()
        .map(_userFromFireAuth);
  }

  // sign in anon
  Future<User?> signInAnon() async {
    try {
      final result = await _auth.signInAnonymously();
      return _userFromFireAuth(result.user);
    } catch (e) {
      print("Failed to sign in anonymously ${e.toString()}");
      return null;
    }
  }

  // sign in email password
  Future<void> signInEmailPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // register email password
  Future<void> registerEmailPassword(String email, String password) async {
    final res = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (res.user != null) {
      await DatabaseService().createNewBrew(res.user!.uid);
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("Failed to sign out ${e.toString()}");
    }
  }
}
