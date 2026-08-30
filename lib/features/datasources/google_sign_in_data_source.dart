import 'package:firebase_auth/firebase_auth.dart';

abstract interface class GoogleSignInDataSource {
  Future<UserCredential> authenticate();

  Future<void> signOut();
}