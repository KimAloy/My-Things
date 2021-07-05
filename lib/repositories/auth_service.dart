import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServicesProvider =
    Provider<AuthenticationService>((ref) => AuthenticationService());

// stream to change screen from login to homepage and vice versa
final authStateProvider = StreamProvider<User?>(
    (ref) => ref.watch(authServicesProvider).authStateChange);

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Delete account
  Future deleteAccount() async {
    User user = _firebaseAuth.currentUser!;
    user.delete();
  }

// Future<String?> signIn(
  //     {required String email, required String password}) async {
  //   try {
  //     await _firebaseAuth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     return 'Login successful';
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }
  //
  // Future<String?> signUp(
  //     {required String email, required String password}) async {
  //   try {
  //     await _firebaseAuth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     return 'Signup successful';
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }
  //

}
