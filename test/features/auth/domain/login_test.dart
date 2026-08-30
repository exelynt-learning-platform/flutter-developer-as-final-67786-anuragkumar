import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:employee_management_app/features/domain/app_user.dart';
import 'package:employee_management_app/features/domain/auth_repository.dart';
import 'package:employee_management_app/features/domain/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late Login login;

  setUp(() {
    repository = MockAuthRepository();
    login = Login(repository);
  });

  test('calls repository with email and password', () async {
    const user = AppUser(
      id: 'user-1',
      email: 'john@example.com',
      name: 'John',
    );

    when(
      () => repository.login(
        email: 'john@example.com',
        password: 'Password123!',
      ),
    ).thenAnswer((_) async => user);

    final result = await login(
      email: 'john@example.com',
      password: 'Password123!',
    );

    expect(result, equals(user));

    verify(
      () => repository.login(
        email: 'john@example.com',
        password: 'Password123!',
      ),
    ).called(1);
  });
}