import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/authentication/domain/repositories/auth_repository.dart';
import 'package:mrpos/features/authentication/presentation/bloc/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  AuthCubit(this._authRepository) : super(const AuthInitial()) {
    _init();
  }

  void _init() {
    _authSubscription = _authRepository.authStateChanges.listen((userId) {
      if (userId != null) {
        emit(
          AuthAuthenticated(userId: userId, email: ''),
        ); // Email can be fetched from User metadata if needed
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      emit(const AuthLoading());
      await _authRepository.login(email, password);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(const AuthLoading());
      await _authRepository.logout();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
