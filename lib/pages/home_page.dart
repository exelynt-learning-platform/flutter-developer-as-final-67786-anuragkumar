import 'package:employee_management_app/app/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Management'),
        actionsPadding: EdgeInsets.only(right: 8),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: authState.isLoading ? null  : () {
              ref.read(authNotifierProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                child: user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        user.photoUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, size: 40);
                        },
                      ),
                    )
                  : const Icon(Icons.person, size: 40),
              ),

              const SizedBox(height: 24),

              Text('Welcome', style: Theme.of(context).textTheme.headlineSmall),

              const SizedBox(height: 8),

              Text(
                user?.name ?? user?.email ?? 'User',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),

              if (user?.email != null) ...[
                const SizedBox(height: 4),

                Align(
                  alignment: Alignment.center,
                  child: Chip(label: Text(user?.email ?? 'User', style: Theme.of(context).textTheme.bodySmall)),
                ),
              ],

              const SizedBox(height: 32),

              const Text('Employee Management Dashboard', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.push('/employees');
                },
                child: const Text('Go to Employee Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
