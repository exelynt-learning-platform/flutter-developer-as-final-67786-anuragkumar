import 'package:employee_management_app/features/domain/app_user.dart';
import 'package:employee_management_app/features/domain/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/failure.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/google_sign_in_data_source.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authDataSource, this._googleSignInDataSource);

  final AuthRemoteDataSource _authDataSource;
  final GoogleSignInDataSource _googleSignInDataSource;

  @override
  AppUser? get currentUser {
    final user = _authDataSource.currentUser;

    if (user == null) {
      return null;
    }

    return AuthUserModel.fromFirebaseUser(user).toEntity();
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _authDataSource.authStateChanges.map(
      (user) {
        if (user == null) {
          return null;
        }

        return AuthUserModel.fromFirebaseUser(user).toEntity();
      },
    );
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await _authDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw const AuthenticationFailure(
          'Authentication failed.',
        );
      }

      return AuthUserModel.fromFirebaseUser(user).toEntity();
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const UnknownFailure(
        'An unexpected authentication error occurred.',
      );
    }
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await _authDataSource.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw const AuthenticationFailure(
          'Unable to create the account.',
        );
      }

      await _authDataSource.updateDisplayName(
        name: name,
      );

      await _authDataSource.reloadCurrentUser();

      final updatedUser = _authDataSource.currentUser;

      if (updatedUser == null) {
        throw const AuthenticationFailure(
          'Unable to retrieve the newly created account.',
        );
      }

      return AuthUserModel.fromFirebaseUser(
        updatedUser,
      ).toEntity();
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const UnknownFailure(
        'An unexpected registration error occurred.',
      );
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      final credential = await _googleSignInDataSource.authenticate();
      final user = credential.user;

      if (user == null) {
        throw const AuthenticationFailure('Unable to complete Google authentication.');
      }

      return AuthUserModel.fromFirebaseUser(user).toEntity();
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    } on Failure {
      rethrow;
    } catch (error) {
      if (error is Failure) {
        rethrow;
      }
      throw GoogleSignInFailure('Google Sign-In failed: $error');
      // throw const GoogleSignInFailure('Google Sign-In failed. Please try again.');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _authDataSource.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    } catch (_) {
      throw const UnknownFailure(
        'Unable to send the password reset email.',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _googleSignInDataSource.signOut();
      await _authDataSource.signOut();
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    } catch (_) {
      throw const UnknownFailure(
        'Unable to log out. Please try again.',
      );
    }
  }

  Failure _mapFirebaseAuthException(
    FirebaseAuthException error,
  ) {
    return switch (error.code) {
      'invalid-credential' ||
      'invalid-login-credentials' ||
      'wrong-password' ||
      'user-not-found' =>
        const InvalidCredentialsFailure(
          'Invalid email or password.',
        ),
      'email-already-in-use' =>
        const EmailAlreadyInUseFailure(
          'An account already exists with this email.',
        ),
      'weak-password' =>
        const WeakPasswordFailure(
          'The password is too weak.',
        ),
      'user-disabled' =>
        const AccountDisabledFailure(
          'This account has been disabled.',
        ),
      'invalid-email' =>
        const ValidationFailure(
          'Please enter a valid email address.',
        ),
      'network-request-failed' =>
        const NetworkFailure(
          'Network error. Please check your connection.',
        ),
      _ =>
        AuthenticationFailure(
          error.message ??
              'Authentication failed. Please try again.',
        ),
    };
  }
}