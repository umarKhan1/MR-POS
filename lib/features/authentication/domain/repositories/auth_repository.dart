abstract class IAuthRepository {
  Future<void> login(String email, String password);
  Future<void> logout();
  Stream<String?> get authStateChanges;
  String? get currentUserId;
}
