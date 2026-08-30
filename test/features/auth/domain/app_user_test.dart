import 'package:flutter_test/flutter_test.dart';

import 'package:employee_management_app/features/domain/app_user.dart';

void main() {
  group('AppUser', () {
    test('two users with the same values are equal', () {
      const first = AppUser(
        id: '1',
        email: 'john@example.com',
        name: 'John',
        photoUrl: 'https://example.com/photo.jpg',
      );

      const second = AppUser(
        id: '1',
        email: 'john@example.com',
        name: 'John',
        photoUrl: 'https://example.com/photo.jpg',
      );

      expect(first, equals(second));
    });

    test('users with different IDs are not equal', () {
      const first = AppUser(
        id: '1',
        email: 'john@example.com',
      );

      const second = AppUser(
        id: '2',
        email: 'john@example.com',
      );

      expect(first, isNot(equals(second)));
    });
  });
}