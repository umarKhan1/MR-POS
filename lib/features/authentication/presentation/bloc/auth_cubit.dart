import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/authentication/presentation/bloc/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    try {
      emit(const AuthLoading());

      // TODO: Implement actual login logic with repository
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // For now, just check if email and password are not empty
      if (email.isNotEmpty && password.isNotEmpty) {
        emit(AuthAuthenticated(userId: '123', email: email));
      } else {
        emit(const AuthError('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(const AuthLoading());

      // TODO: Implement actual logout logic
      await Future.delayed(const Duration(milliseconds: 500));

      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void checkAuthStatus() {
    // TODO: Check if user is already logged in (from Hive)
    emit(const AuthUnauthenticated());
  }
}
