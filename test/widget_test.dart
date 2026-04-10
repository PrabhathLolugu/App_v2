import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Widget smoke test compiles and renders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Text('MyItihas')),
      ),
    );

    expect(find.text('MyItihas'), findsOneWidget);
  });
}
