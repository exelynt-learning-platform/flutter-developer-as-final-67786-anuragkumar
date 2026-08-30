import 'app_user.dart';
import 'auth_repository.dart';

class Login {
  const Login(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call({
    required String email,
    required String password,
  }) {
    return _repository.login(
      email: email,
      password: password,
    );
  }
}

class Register {
  const Register(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}

class SignInWithGoogle {
  const SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call() {
    return _repository.signInWithGoogle();
  }
}

class SendPasswordReset {
  const SendPasswordReset(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String email,
  }) {
    return _repository.sendPasswordResetEmail(
      email: email,
    );
  }
}

class Logout {
  const Logout(this._repository);

  final AuthRepository _repository;

  Future<void> call() {
    return _repository.logout();
  }
}

class WatchAuthState {
  const WatchAuthState(this._repository);

  final AuthRepository _repository;

  AppUser? get currentUser => _repository.currentUser;

  Stream<AppUser?> call() {
    return _repository.authStateChanges;
  }
}