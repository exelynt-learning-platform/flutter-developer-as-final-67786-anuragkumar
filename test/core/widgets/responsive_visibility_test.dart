import 'package:employee_management_app/core/widgets/responsive_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ResponsiveVisibility shows mobile on small screens', (tester) async {
    tester.view.physicalSize = const Size(700, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ResponsiveVisibility(
            mobile: Text('mobile-only'),
            desktop: Text('desktop-only'),
          ),
        ),
      ),
    );

    expect(find.text('mobile-only'), findsOneWidget);
    expect(find.text('desktop-only'), findsNothing);
  });

  testWidgets('ResponsiveVisibility shows desktop on wide screens', (tester) async {
    tester.view.physicalSize = const Size(1000, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ResponsiveVisibility(
            mobile: Text('mobile-only'),
            desktop: Text('desktop-only'),
          ),
        ),
      ),
    );

    expect(find.text('desktop-only'), findsOneWidget);
    expect(find.text('mobile-only'), findsNothing);
  });
}
