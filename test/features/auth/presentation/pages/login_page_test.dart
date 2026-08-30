import 'package:employee_management_app/app/providers/auth_providers.dart';
import 'package:employee_management_app/app/providers/auth_state.dart';
import 'package:employee_management_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../shared/test_helpers.dart';
void main() {
  testWidgets('LoginPage validates required fields', (tester) async {
    final fakeAuth = FakeAuthNotifier(const AuthState.unauthenticated());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authNotifierProvider.overrideWith(() => fakeAuth)],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(fakeAuth.loginCalls, 0);
  });

  testWidgets('LoginPage submits valid email and password', (tester) async {
    final fakeAuth = FakeAuthNotifier(const AuthState.unauthenticated());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authNotifierProvider.overrideWith(() => fakeAuth)],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'alice@example.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'secret123');
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(fakeAuth.loginCalls, 1);
    expect(fakeAuth.lastLoginEmail, 'alice@example.com');
    expect(fakeAuth.lastLoginPassword, 'secret123');
  });

  testWidgets('LoginPage Google sign-in button triggers notifier', (tester) async {
    final fakeAuth = FakeAuthNotifier(const AuthState.unauthenticated());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authNotifierProvider.overrideWith(() => fakeAuth)],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.tap(find.text('Continue with Google'));
    await tester.pump();

    expect(fakeAuth.googleSignInCalls, 1);
  });
}
