import 'package:employee_management_app/app/providers/auth_providers.dart';
import 'package:employee_management_app/app/providers/auth_state.dart';
import 'package:employee_management_app/features/domain/app_user.dart';
import 'package:employee_management_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/test_helpers.dart';

void main() {
  testWidgets('HomePage shows user info and handles logout', (tester) async {
    final fakeAuth = FakeAuthNotifier(
      const AuthState.authenticated(
        AppUser(id: 'u1', email: 'alice@example.com', name: 'Alice'),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authNotifierProvider.overrideWith(() => fakeAuth)],
        child: const MaterialApp(home: HomePage()),
      ),
    );

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('alice@example.com'), findsOneWidget);

    await tester.tap(find.byTooltip('Logout'));
    await tester.pump();

    expect(fakeAuth.logoutCalls, 1);
  });

  testWidgets('HomePage navigates to employee dashboard', (tester) async {
    final fakeAuth = FakeAuthNotifier(
      const AuthState.authenticated(
        AppUser(id: 'u1', email: 'alice@example.com', name: 'Alice'),
      ),
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/employees',
          builder: (context, state) => const Scaffold(body: Center(child: Text('Employee Dashboard Screen'))),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authNotifierProvider.overrideWith(() => fakeAuth)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.tap(find.text('Go to Employee Dashboard'));
    await tester.pumpAndSettle();

    expect(find.text('Employee Dashboard Screen'), findsOneWidget);
  });
}
