import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tipsplit/main.dart';

void main() {
  testWidgets('renders core UI elements', (tester) async {
    await tester.pumpWidget(const TipsplitApp());

    expect(find.text('Tipsplit'), findsWidgets);
    expect(find.text('Bill amount'), findsOneWidget);
    expect(find.text('15%'), findsOneWidget);
    expect(find.text('Split between'), findsOneWidget);
    expect(find.text('Round up total'), findsOneWidget);
  });

  testWidgets('updates results as bill amount is typed', (tester) async {
    await tester.pumpWidget(const TipsplitApp());

    await tester.enterText(
      find.widgetWithText(TextField, 'Bill amount'),
      '100',
    );
    await tester.pump();

    expect(find.text('\$20.00'), findsOneWidget);
    expect(find.text('\$120.00'), findsNWidgets(2));
  });

  testWidgets('quick tip buttons change selection', (tester) async {
    await tester.pumpWidget(const TipsplitApp());

    await tester.enterText(
      find.widgetWithText(TextField, 'Bill amount'),
      '100',
    );
    await tester.tap(find.text('25%'));
    await tester.pump();

    expect(find.text('\$25.00'), findsOneWidget);
    expect(find.text('\$125.00'), findsNWidgets(2));
  });

  testWidgets('increments people and splits total', (tester) async {
    await tester.pumpWidget(const TipsplitApp());

    await tester.enterText(
      find.widgetWithText(TextField, 'Bill amount'),
      '100',
    );
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();

    expect(find.text('Per person (2)'), findsOneWidget);
    expect(find.text('\$60.00'), findsOneWidget);
  });
}
