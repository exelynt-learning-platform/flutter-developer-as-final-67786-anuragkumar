import 'package:employee_management_app/app/providers/auth_providers.dart';
import 'package:employee_management_app/app/providers/auth_state.dart';
import 'package:employee_management_app/core/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();

    ref.listenManual<AuthState>(authNotifierProvider, ((previous, next) {
      if (next.isAuthenticated) {
        AppSnackbar.success('Login successful');
        // Navigate to the home page or perform other actions
      } else if (next.status == AuthStatus.failure) {
        AppSnackbar.error(next.message ?? 'An error occurred');
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Employee Management',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Continue with Google to sign in',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      const SizedBox(height: 28),

                      OutlinedButton.icon(
                        onPressed: authState.isLoading
                            ? null
                            : () {
                                ref.read(authNotifierProvider.notifier).signInWithGoogle();
                              },
                        icon: authState.isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.g_mobiledata),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Continue with Google'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}