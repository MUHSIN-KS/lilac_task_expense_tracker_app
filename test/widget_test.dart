// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:lilac_company_task/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const MyApp());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }
import 'package:flutter_test/flutter_test.dart';
import 'package:lilac_company_task/utils/validators.dart';

void main() {
  group('Amount validator', () {
    test('rejects empty value', () {
      expect(Validators.amount(''), 'Amount is required');
    });

    test('rejects non-numeric value', () {
      expect(Validators.amount('abc'), 'Enter a valid number');
    });

    test('rejects zero and negative numbers', () {
      expect(Validators.amount('0'), 'Amount must be greater than 0');
      expect(Validators.amount('-5'), 'Amount must be greater than 0');
    });

    test('accepts a positive number', () {
      expect(Validators.amount('850.50'), isNull);
    });
  });
}