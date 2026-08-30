import 'package:employee_management_app/app/providers/employee_providers.dart';
import 'package:employee_management_app/app/providers/employee_state.dart';
import 'package:employee_management_app/features/domain/employee_state.dart';
import 'package:employee_management_app/features/models/country_model.dart';
import 'package:employee_management_app/features/models/employee_model.dart';
import 'package:employee_management_app/pages/add_employee_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

class FakeGetCountries implements GetCountries {
  FakeGetCountries(this.countries);

  final List<CountryModel> countries;

  @override
  Future<List<CountryModel>> call() async => countries;
}

class NullCreateEmployeeNotifier extends FakeEmployeeNotifier {
  NullCreateEmployeeNotifier(super.initialState);

  @override
  Future<Employee?> createEmployee(Employee employee) async {
    createCalls += 1;
    lastCreatedEmployee = employee;
    state = const EmployeeState.failure('Unable to create employee.');
    return null;
  }
}

void main() {
  testWidgets('AddEmployeePage shows edit mode values', (tester) async {
    final fakeEmployee = FakeEmployeeNotifier(const EmployeeState.success([sampleEmployee]));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          employeeNotifierProvider.overrideWith(() => fakeEmployee),
          getCountriesProvider.overrideWith((ref) => FakeGetCountries(const [sampleCountry])),
        ],
        child: const MaterialApp(home: AddEmployeePage(employee: sampleEmployee)),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Edit Employee'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('alice@example.com'), findsOneWidget);
    expect(find.text('9876543210'), findsOneWidget);
    expect(find.text('Karnataka'), findsOneWidget);
    expect(find.text('Bengaluru'), findsOneWidget);
  });

  testWidgets('AddEmployeePage saves a valid new employee', (tester) async {
    final fakeEmployee = NullCreateEmployeeNotifier(const EmployeeState.success([]));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          employeeNotifierProvider.overrideWith(() => fakeEmployee),
          getCountriesProvider.overrideWith((ref) => FakeGetCountries(const [sampleCountry])),
        ],
        child: const MaterialApp(home: AddEmployeePage()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Charlie');
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'charlie@example.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Mobile'), '9988776655');
    await tester.enterText(find.widgetWithText(TextFormField, 'State'), 'Kerala');
    await tester.enterText(find.widgetWithText(TextFormField, 'District'), 'Kochi');

    await tester.tap(find.byType(DropdownButtonFormField<CountryModel>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('India').last);
    await tester.pumpAndSettle();

    final saveButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Save Employee'),
    );
    expect(saveButton.onPressed, isNotNull);

    await tester.tap(find.widgetWithText(FilledButton, 'Save Employee'));
    await tester.pump();

    expect(fakeEmployee.createCalls, 1);
    expect(fakeEmployee.lastCreatedEmployee?.name, 'Charlie');
    expect(fakeEmployee.lastCreatedEmployee?.country, 'India');
  });
}
