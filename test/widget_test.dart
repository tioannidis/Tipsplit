import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tipsplit/main.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const TipsplitApp());
    await tester.pump();
  }

  Future<void> enterBill(
    WidgetTester tester,
    String text, {
    String label = 'Bill Amount (\$)',
  }) async {
    await tester.enterText(find.widgetWithText(TextField, label), text);
    await tester.pump();
  }

  testWidgets('renders the original HTML layout', (tester) async {
    await pumpApp(tester);

    expect(find.text('🍽️'), findsOneWidget);
    expect(find.text('Tipsplit'), findsOneWidget);
    expect(find.text('Bill Amount (\$)'), findsOneWidget);
    expect(find.text('Tip %'), findsOneWidget);
    expect(find.text('Custom'), findsOneWidget);
    expect(find.text('Number of People'), findsOneWidget);
    expect(find.text('Round Up to Next Dollar'), findsOneWidget);
    expect(find.text('Tip Amount:'), findsOneWidget);
    expect(find.text('Total Amount:'), findsOneWidget);
    expect(find.text('Per Person:'), findsOneWidget);
  });

  testWidgets('defaults to 15% tip and updates as bill is typed',
      (tester) async {
    await pumpApp(tester);

    await enterBill(tester, '100');

    expect(find.text('\$15.00'), findsOneWidget);
    expect(find.text('\$115.00'), findsNWidgets(2));
  });

  testWidgets('selecting a quick tip changes the result', (tester) async {
    await pumpApp(tester);

    await enterBill(tester, '100');
    await tester.tap(find.text('25%'));
    await tester.pump();

    expect(find.text('\$25.00'), findsOneWidget);
    expect(find.text('\$125.00'), findsNWidgets(2));
  });

  testWidgets('custom tip shows input field and uses its value',
      (tester) async {
    await pumpApp(tester);

    await enterBill(tester, '100');
    await tester.tap(find.text('Custom'));
    await tester.pump();

    expect(find.text('Custom Tip %'), findsOneWidget);
    await enterBill(tester, '12', label: 'Custom Tip %');
    await tester.pump();

    expect(find.text('\$12.00'), findsOneWidget);
    expect(find.text('\$112.00'), findsNWidgets(2));
  });

  testWidgets('splits per person by number of people', (tester) async {
    await pumpApp(tester);

    await enterBill(tester, '90');
    await tester.enterText(
      find.widgetWithText(TextField, 'Number of People'),
      '3',
    );
    await tester.pump();

    expect(find.text('\$103.50'), findsOneWidget);
    expect(find.text('\$34.50'), findsOneWidget);
  });

  testWidgets('round up button rounds total to next dollar',
      (tester) async {
    await pumpApp(tester);

    await enterBill(tester, '42.37');
    expect(find.text('\$48.73'), findsOneWidget);

    await tester.tap(find.text('Round Up to Next Dollar'));
    await tester.pump();

    expect(find.text('\$49.00'), findsOneWidget);
    expect(find.text('\$6.63'), findsOneWidget);
    expect(find.text('\$24.50'), findsOneWidget);
  });

  testWidgets('round up does nothing for zero bill', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Round Up to Next Dollar'));
    await tester.pump();

    expect(find.text('\$0.00'), findsNWidgets(3));
  });

  testWidgets('editing an input after round up resets rounding',
      (tester) async {
    await pumpApp(tester);

    await enterBill(tester, '42.37');
    await tester.tap(find.text('Round Up to Next Dollar'));
    await tester.pump();
    expect(find.text('\$49.00'), findsOneWidget);

    await enterBill(tester, '42.38');
    await tester.pump();

    expect(find.text('\$48.74'), findsOneWidget);
  });
}
