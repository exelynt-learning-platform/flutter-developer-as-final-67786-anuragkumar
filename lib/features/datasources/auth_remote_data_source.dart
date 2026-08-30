import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  User? get currentUser;

  Stream<User?> get authStateChanges;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> updateDisplayName({
    required String name,
  });

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> signInWithCredential(
    AuthCredential credential,
  );

  Future<void> signOut();

  Future<void> reloadCurrentUser();
}