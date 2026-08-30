import 'package:employee_management_app/features/models/employee_model.dart';
import 'package:employee_management_app/widgets/employee_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const employee = Employee(
    id: 'e-1',
    name: 'Alice',
    email: 'alice@example.com',
    mobile: '9876543210',
    country: 'India',
    state: 'Karnataka',
    district: 'Bengaluru',
  );

  testWidgets('EmployeeCard renders key employee details', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmployeeCard(
            employee: employee,
            onDelete: (_) {},
            onEdit: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('ID: e-1'), findsOneWidget);
    expect(find.text('alice@example.com'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });

  testWidgets('EmployeeCard edit and delete callbacks are triggered', (tester) async {
    Employee? edited;
    Employee? deleted;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmployeeCard(
            employee: employee,
            onDelete: (value) => deleted = value,
            onEdit: (value) => edited = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Edit employee'));
    await tester.pump();
    await tester.tap(find.byTooltip('Delete employee'));
    await tester.pump();

    expect(edited, employee);
    expect(deleted, employee);
  });
}
