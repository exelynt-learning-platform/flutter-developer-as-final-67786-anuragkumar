import 'package:employee_management_app/features/models/employee_model.dart';
import 'package:employee_management_app/widgets/employee_card.dart';
import 'package:employee_management_app/widgets/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const employees = [
    Employee(
      id: '1',
      name: 'Alice',
      email: 'alice@example.com',
      mobile: '9876543210',
      country: 'India',
      state: 'Karnataka',
      district: 'Bengaluru',
    ),
    Employee(
      id: '2',
      name: 'Bob',
      email: 'bob@example.com',
      mobile: '9123456780',
      country: 'USA',
      state: 'California',
      district: 'San Jose',
    ),
  ];

  testWidgets('EmployeeList shows cards on mobile width', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmployeeList(
            employees: employees,
            onDelete: (_) {},
            onEdit: (_) {},
          ),
        ),
      ),
    );

    expect(find.byType(EmployeeCard), findsNWidgets(2));
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
  });

  testWidgets('EmployeeList shows table headers on desktop width', (tester) async {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmployeeList(
            employees: employees,
            onDelete: (_) {},
            onEdit: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Actions'), findsOneWidget);
    expect(find.text('ID'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
  });
}
