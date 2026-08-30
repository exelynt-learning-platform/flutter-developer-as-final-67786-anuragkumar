import 'package:employee_management_app/app/providers/auth_providers.dart';
import 'package:employee_management_app/app/providers/auth_state.dart';
import 'package:employee_management_app/features/models/employee_model.dart';
import 'package:employee_management_app/features/employee/presentation/pages/add_employee_page.dart';
import 'package:employee_management_app/features/employee/presentation/pages/employee_dashboard_page.dart';
import 'package:employee_management_app/features/home/presentation/pages/home_page.dart';
import 'package:employee_management_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  final router = GoRouter(
    initialLocation: '/login',

    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      if (isAuthenticated && isLoginRoute) {
        return '/';
      }

      return null;
    },

    errorBuilder: (context, state) => NavigationErrorPage(state: state),

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: '/employees',
        name: 'employee_dashboard',
        builder: (context, state) => const EmployeeDashboardPage(),
        routes: [
          GoRoute(
            path: '/add',
            builder: (context, state) => const AddEmployeePage(),
          ),
          GoRoute(
            path: '/edit/:id',
            builder: (context, state) {
              final employee = state.extra as Employee;
              return AddEmployeePage(employee: employee);
            },
          ),
        ]
      ),

      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );

  ref.onDispose(router.dispose);

  return router;
});

class NavigationErrorPage extends StatelessWidget {
  const NavigationErrorPage({required this.state, super.key});

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    final message = state.error?.toString() ?? 'Unknown navigation error';
    debugPrint('GO ROUTER ERROR: $message');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Error'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
