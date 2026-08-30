import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:employee_management_app/features/datasources/auth_remote_data_source.dart';
import 'package:employee_management_app/features/datasources/google_sign_in_data_source.dart';
import 'package:employee_management_app/features/repositories/auth_repository_impl.dart';
import 'package:employee_management_app/features/domain/app_user.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockGoogleSignInDataSource extends Mock implements GoogleSignInDataSource {}
  
class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuthRemoteDataSource authDataSource;
  late MockGoogleSignInDataSource googleDataSource;
  late AuthRepositoryImpl  repository;

  setUp(() {
    authDataSource = MockAuthRemoteDataSource();
    googleDataSource = MockGoogleSignInDataSource();

    repository = AuthRepositoryImpl(
      authDataSource,
      googleDataSource,
    );
  });

  group('login', () {
    test('returns AppUser when Firebase login succeeds', () async {
      final credential = MockUserCredential();
      final user = MockUser();

      when(() => credential.user).thenReturn(user);

      when(() => user.uid).thenReturn('user-1');
      when(() => user.email).thenReturn('john@example.com');
      when(() => user.displayName).thenReturn('John');
      when(() => user.photoURL).thenReturn(null);

      when(
        () => authDataSource.signInWithEmailAndPassword(
          email: 'john@example.com',
          password: 'Password123!',
        ),
      ).thenAnswer((_) async => credential);

      final result = await repository.login(
        email: 'john@example.com',
        password: 'Password123!',
      );

      expect(
        result,
        equals(
          const AppUser(
            id: 'user-1',
            email: 'john@example.com',
            name: 'John',
          ),
        ),
      );
    });
  });
}