import 'package:employee_management_app/app/providers/auth_providers.dart';
import 'package:employee_management_app/app/providers/employee_providers.dart';
import 'package:employee_management_app/features/models/employee_model.dart';
import 'package:employee_management_app/features/employee/presentation/pages/add_employee_page.dart';
import 'package:employee_management_app/features/employee/presentation/pages/employee_dashboard_page.dart';
import 'package:employee_management_app/features/home/presentation/pages/home_page.dart';
import 'package:employee_management_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  ref.listen(authNotifierProvider, (_, __) {
    refreshNotifier.notify();
  });

  final router = GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshNotifier,

    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
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
              final employeeId = state.pathParameters['id'] ?? '';
              return _EditEmployeeRouteResolver(
                employeeId: employeeId,
                extra: state.extra,
              );
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

  ref.onDispose(() {
    refreshNotifier.dispose();
    router.dispose();
  });

  return router;
});

class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

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

class _EditEmployeeRouteResolver extends ConsumerWidget {
  const _EditEmployeeRouteResolver({
    required this.employeeId,
    required this.extra,
  });

  final String employeeId;
  final Object? extra;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (extra is Employee) {
      return AddEmployeePage(employee: extra as Employee);
    }

    if (employeeId.trim().isEmpty) {
      return const _RouteFallbackPage(
        title: 'Unable to Edit Employee',
        message: 'Employee ID is missing from the route.',
      );
    }

    return FutureBuilder<Employee?>(
      future: ref
          .read(employeeNotifierProvider.notifier)
          .getEmployeeById(employeeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return _RouteFallbackPage(
            title: 'Unable to Edit Employee',
            message: snapshot.error.toString(),
          );
        }

        final employee = snapshot.data;
        if (employee == null) {
          return const _RouteFallbackPage(
            title: 'Employee Not Found',
            message: 'Unable to find employee for the requested ID.',
          );
        }

        return AddEmployeePage(employee: employee);
      },
    );
  }
}

class _RouteFallbackPage extends StatelessWidget {
  const _RouteFallbackPage({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_outlined, size: 48),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/employees'),
                child: const Text('Back to Employees'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
