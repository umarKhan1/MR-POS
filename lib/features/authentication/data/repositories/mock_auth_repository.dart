import 'dart:async';
import 'package:mrpos/features/authentication/domain/repositories/auth_repository.dart';

class MockAuthRepository implements IAuthRepository {
  final _controller = StreamController<String?>.broadcast();
  String? _userId;

  @override
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'admin@mrpos.com' && password == 'admin123') {
      _userId = 'demo_user_123';
      _controller.add(_userId);
    } else {
      throw Exception('Invalid demo credentials');
    }
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _userId = null;
    _controller.add(null);
  }

  @override
  Stream<String?> get authStateChanges => _controller.stream;

  @override
  String? get currentUserId => _userId;
}
