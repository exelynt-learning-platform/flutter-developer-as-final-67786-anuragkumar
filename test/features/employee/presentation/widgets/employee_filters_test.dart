import 'package:employee_management_app/features/employee/presentation/widgets/employee_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EmployeeFilters calls onChanged when fields are edited', (tester) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final mobileController = TextEditingController();
    final countryController = TextEditingController();
    var changedCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmployeeFilters(
            nameController: nameController,
            emailController: emailController,
            mobileController: mobileController,
            countryController: countryController,
            onChanged: () => changedCount += 1,
          ),
        ),
      ),
    );

    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Alice');
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'alice@example.com');

    expect(nameController.text, 'Alice');
    expect(emailController.text, 'alice@example.com');
    expect(changedCount, greaterThanOrEqualTo(2));
  });
}
