import 'package:employee_management_app/app/providers/auth_notifier.dart';
import 'package:employee_management_app/app/providers/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/datasources/auth_remote_data_source.dart';
import '../../features/datasources/google_sign_in_data_source.dart';
import '../../features/repositories/auth_repository_impl.dart';
import '../../features/domain/auth_repository.dart';
import '../../features/domain/auth_state.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  throw UnimplementedError('Firebase datasource has not been configured.',);
});

final googleSignInDataSourceProvider = Provider<GoogleSignInDataSource>((ref) {
  throw UnimplementedError('Google Sign-In datasource has not been configured.',);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(googleSignInDataSourceProvider),
  );
});

final loginProvider = Provider<Login>((ref) {
  return Login(ref.watch(authRepositoryProvider));
});

final registerProvider = Provider<Register>((ref) {
  return Register(ref.watch(authRepositoryProvider));
});

final signInWithGoogleProvider = Provider<SignInWithGoogle>((ref) {
  return SignInWithGoogle(ref.watch(authRepositoryProvider));
});

final sendPasswordResetProvider = Provider<SendPasswordReset>((ref) {
  return SendPasswordReset(ref.watch(authRepositoryProvider));
});

final logoutProvider = Provider<Logout>((ref) {
  return Logout(ref.watch(authRepositoryProvider));
});

final watchAuthStateProvider = Provider<WatchAuthState>((ref) {
  return WatchAuthState(ref.watch(authRepositoryProvider));
});

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
