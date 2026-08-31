import 'package:employee_management_app/app/providers/auth_providers.dart';
import 'package:employee_management_app/app/providers/auth_state.dart';
import 'package:employee_management_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared/test_helpers.dart';

void main() {
  testWidgets(
    'Login page renders in test environment',
    (tester) async {
      final fakeAuth = FakeAuthNotifier(const AuthState.unauthenticated());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authNotifierProvider.overrideWith(() => fakeAuth)],
          child: const MaterialApp(home: LoginPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Employee Management'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
    },
  );
}
