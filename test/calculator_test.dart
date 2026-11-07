import 'package:flutter_test/flutter_test.dart';
import 'package:tipsplit/calculator.dart';

void main() {
  const calculator = TipCalculator();
  const epsilon = 0.001;

  group('parseAmount', () {
    test('parses plain numbers', () {
      expect(calculator.parseAmount('42.50'), 42.50);
    });

    test('parses comma as decimal separator', () {
      expect(calculator.parseAmount('42,50'), 42.50);
    });

    test('returns zero for empty input', () {
      expect(calculator.parseAmount(''), 0.0);
    });

    test('returns zero for invalid input', () {
      expect(calculator.parseAmount('abc'), 0.0);
    });

    test('returns zero for negative input', () {
      expect(calculator.parseAmount('-5'), 0.0);
    });
  });

  group('parsePeople', () {
    test('parses valid counts', () {
      expect(calculator.parsePeople('3'), 3);
    });

    test('falls back to one for empty input', () {
      expect(calculator.parsePeople(''), 1);
    });

    test('falls back to one for invalid input', () {
      expect(calculator.parsePeople('abc'), 1);
    });

    test('falls back to one for zero', () {
      expect(calculator.parsePeople('0'), 1);
    });
  });

  group('calculate', () {
    test('computes tip and total', () {
      final result = calculator.calculate(
        billAmount: 100,
        tipPercent: 20,
        people: 1,
        roundUp: false,
      );

      expect(result.tipAmount, closeTo(20, epsilon));
      expect(result.total, closeTo(120, epsilon));
      expect(result.perPerson, closeTo(120, epsilon));
    });

    test('splits bill among people', () {
      final result = calculator.calculate(
        billAmount: 90,
        tipPercent: 10,
        people: 3,
        roundUp: false,
      );

      expect(result.total, closeTo(99, epsilon));
      expect(result.perPerson, closeTo(33, epsilon));
    });

    test('uses zero tip for custom tip without input', () {
      final result = calculator.calculate(
        billAmount: 50,
        tipPercent: 0,
        people: 1,
        roundUp: false,
      );

      expect(result.tipAmount, 0.0);
      expect(result.total, closeTo(50, epsilon));
    });

    test('rounds total up when enabled', () {
      final result = calculator.calculate(
        billAmount: 42.37,
        tipPercent: 15,
        people: 2,
        roundUp: true,
      );

      expect(result.total, 49.0);
      expect(result.tipAmount, closeTo(6.63, epsilon));
      expect(result.perPerson, closeTo(24.50, epsilon));
    });

    test('ignores round up for zero bill', () {
      final result = calculator.calculate(
        billAmount: 0,
        tipPercent: 20,
        people: 4,
        roundUp: true,
      );

      expect(result.tipAmount, 0.0);
      expect(result.total, 0.0);
      expect(result.perPerson, 0.0);
    });
  });
}
