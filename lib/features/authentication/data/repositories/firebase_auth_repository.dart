import 'package:firebase_auth/firebase_auth.dart';
import 'package:mrpos/features/authentication/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> login(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<String?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map((user) => user?.uid);

  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;
}
