import 'package:employee_management_app/core/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ResponsiveLayout shows mobile on narrow width', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ResponsiveLayout(
            mobile: Text('mobile'),
            desktop: Text('desktop'),
          ),
        ),
      ),
    );

    expect(find.text('mobile'), findsOneWidget);
    expect(find.text('desktop'), findsNothing);
  });

  testWidgets('ResponsiveLayout shows desktop on wide width', (tester) async {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ResponsiveLayout(
            mobile: Text('mobile'),
            desktop: Text('desktop'),
          ),
        ),
      ),
    );

    expect(find.text('desktop'), findsOneWidget);
    expect(find.text('mobile'), findsNothing);
  });
}
