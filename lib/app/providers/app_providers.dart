import 'package:employee_management_app/features/datasources/auth_remote_data_source.dart';
import 'package:employee_management_app/features/datasources/firebase_auth_remote_data_source.dart';
import 'package:employee_management_app/features/datasources/google_sign_in_data_source.dart';
import 'package:employee_management_app/features/datasources/google_sign_in_data_source_impl.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client.dart';
import '../../core/storage/preferences_storage.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final preferencesStorageFactoryProvider = Provider<PreferencesStorage Function()>((ref) {
  return () {
    try {
      return PreferencesStorageImpl(SharedPreferencesAsync());
    } catch (_) {
      return InMemoryPreferencesStorage();
    }
  };
});

final preferencesStorageProvider = Provider<PreferencesStorage>((ref) {
  final createStorage = ref.watch(preferencesStorageFactoryProvider);
  return createStorage();
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return FirebaseAuthRemoteDataSource(ref.watch(firebaseAuthProvider));
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn.instance;
});

final googleSignInDataSourceProvider = Provider<GoogleSignInDataSource>((ref) {
  return GoogleSignInDataSourceImpl(ref.watch(googleSignInProvider), ref.watch(firebaseAuthProvider));
});