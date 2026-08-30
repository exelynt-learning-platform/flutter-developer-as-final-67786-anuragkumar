import 'package:flutter/foundation.dart';

import '../../features/domain/app_user.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
}

@immutable
class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.message,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        message = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        message = null;

  const AuthState.authenticated(this.user)
      : status = AuthStatus.authenticated,
        message = null;

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        message = null;

  const AuthState.failure(this.message)
      : status = AuthStatus.failure,
        user = null;

  final AuthStatus status;
  final AppUser? user;
  final String? message;

  bool get isLoading => status == AuthStatus.loading;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AuthState &&
            runtimeType == other.runtimeType &&
            status == other.status &&
            user == other.user &&
            message == other.message;
  }

  @override
  int get hashCode => Object.hash(status, user, message);
}
