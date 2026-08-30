import 'package:employee_management_app/app/providers/employee_providers.dart';
import 'package:employee_management_app/app/providers/employee_state.dart';
import 'package:employee_management_app/features/employee/presentation/pages/employee_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/test_helpers.dart';

void main() {
  testWidgets('EmployeeDashboardPage loads employees and renders list', (tester) async {
    final fakeEmployee = FakeEmployeeNotifier(
      const EmployeeState.success([sampleEmployee, secondEmployee]),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [employeeNotifierProvider.overrideWith(() => fakeEmployee)],
        child: const MaterialApp(home: EmployeeDashboardPage()),
      ),
    );

    await tester.pump();

    expect(fakeEmployee.loadEmployeesCalls, 1);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
  });

  testWidgets('EmployeeDashboardPage search field updates provider query', (tester) async {
    final fakeEmployee = FakeEmployeeNotifier(
      const EmployeeState.success([sampleEmployee, secondEmployee]),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [employeeNotifierProvider.overrideWith(() => fakeEmployee)],
        child: const MaterialApp(home: EmployeeDashboardPage()),
      ),
    );

    await tester.enterText(find.widgetWithText(TextField, 'Search by Employee ID'), '2');
    await tester.pump();

    expect(fakeEmployee.searchCalls, greaterThan(0));
    expect(fakeEmployee.lastSearchQuery, '2');
  });

  testWidgets('EmployeeDashboardPage opens mobile filters and clear action', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final fakeEmployee = FakeEmployeeNotifier(
      const EmployeeState.success([sampleEmployee]),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [employeeNotifierProvider.overrideWith(() => fakeEmployee)],
        child: const MaterialApp(home: EmployeeDashboardPage()),
      ),
    );

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();

    expect(find.text('Filters'), findsOneWidget);
    await tester.tap(find.text('Clear filters'));
    await tester.pump();

    expect(fakeEmployee.updateFiltersCalls, greaterThan(0));
  });

  testWidgets('EmployeeDashboardPage navigates to add employee page', (tester) async {
    final fakeEmployee = FakeEmployeeNotifier(
      const EmployeeState.success([sampleEmployee]),
    );

    final router = GoRouter(
      initialLocation: '/employees',
      routes: [
        GoRoute(path: '/employees', builder: (context, state) => const EmployeeDashboardPage()),
        GoRoute(
          path: '/employees/add',
          builder: (context, state) => const Scaffold(body: Center(child: Text('Add Employee Screen'))),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [employeeNotifierProvider.overrideWith(() => fakeEmployee)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.tap(find.byTooltip('Add employee'));
    await tester.pumpAndSettle();

    expect(find.text('Add Employee Screen'), findsOneWidget);
  });
}
