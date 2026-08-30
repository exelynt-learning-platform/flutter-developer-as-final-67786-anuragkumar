import 'package:employee_management_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TextControl renders and triggers onChanged', (tester) async {
    final controller = TextEditingController();
    String? changedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: TextControl(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'Alice');

    expect(controller.text, 'Alice');
    expect(changedValue, 'Alice');
  });

  testWidgets('TextControl validator returns expected message', (tester) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: TextControl(
              controller: TextEditingController(),
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
            ),
          ),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Required'), findsOneWidget);
  });
}
