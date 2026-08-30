import 'dart:async';

import 'package:employee_management_app/app/providers/auth_providers.dart';
import 'package:employee_management_app/app/providers/auth_state.dart';
import 'package:employee_management_app/core/error/failure.dart';
import 'package:employee_management_app/features/domain/app_user.dart';
import 'package:employee_management_app/features/domain/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends Notifier<AuthState> {
  late final Login _login;
  late final Register _register;
  late final SignInWithGoogle _signInWithGoogle;
  late final SendPasswordReset _sendPasswordReset;
  late final Logout _logout;
  late final WatchAuthState _watchAuthState;

  StreamSubscription<AppUser?>? _authSubscription;

  @override
  AuthState build() {
    _login = ref.watch(loginProvider);
    _register = ref.watch(registerProvider);
    _signInWithGoogle = ref.watch(signInWithGoogleProvider);
    _sendPasswordReset = ref.watch(sendPasswordResetProvider);
    _logout = ref.watch(logoutProvider);
    _watchAuthState = ref.watch(watchAuthStateProvider);

    ref.onDispose(() {
      _authSubscription?.cancel();
    });

    _startAuthListener();

    return const AuthState.initial();
  }

  void _startAuthListener() {
    _authSubscription = _watchAuthState().listen(
      (user) {
        state = user == null
            ? const AuthState.unauthenticated()
            : AuthState.authenticated(user);
      },
      onError: (Object error) {
        state = AuthState.failure(
          _messageFromError(error),
        );
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    try {
      final user = await _login(
        email: email,
        password: password,
      );

      state = AuthState.authenticated(user);
    } catch (error) {
      state = AuthState.failure(
        _messageFromError(error),
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    try {
      final user = await _register(
        name: name,
        email: email,
        password: password,
      );

      state = AuthState.authenticated(user);
    } catch (error) {
      state = AuthState.failure(
        _messageFromError(error),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();

    try {
      final user = await _signInWithGoogle();

      state = AuthState.authenticated(user);
    } catch (error) {
      state = AuthState.failure(
        _messageFromError(error),
      );
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    state = const AuthState.loading();

    try {
      await _sendPasswordReset(
        email: email,
      );

      state = const AuthState.unauthenticated();
    } catch (error) {
      state = AuthState.failure(
        _messageFromError(error),
      );
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();

    try {
      await _logout();

      state = const AuthState.unauthenticated();
    } catch (error) {
      state = AuthState.failure(
        _messageFromError(error),
      );
    }
  }

  String _messageFromError(Object error) {
    if (error is Failure) {
      return error.message;
    }

    return 'Something went wrong. Please try again.';
  }
}