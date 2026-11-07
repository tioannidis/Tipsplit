import 'dart:math';

class BillResult {
  final double tipAmount;
  final double total;
  final double perPerson;

  const BillResult({
    required this.tipAmount,
    required this.total,
    required this.perPerson,
  });
}

class TipCalculator {
  const TipCalculator();

  double parseAmount(String input) {
    final cleaned = input.replaceAll(',', '.').trim();
    if (cleaned.isEmpty) {
      return 0.0;
    }
    final value = double.tryParse(cleaned);
    if (value == null || value < 0) {
      return 0.0;
    }
    return value;
  }

  BillResult calculate({
    required double billAmount,
    required double tipPercent,
    required int people,
    required bool roundUp,
  }) {
    final bill = max(0.0, billAmount);
    final percent = max(0.0, tipPercent);
    final split = max(1, people);

    var tip = bill * percent / 100;
    var total = bill + tip;

    if (roundUp) {
      total = total.ceilToDouble();
      tip = total - bill;
    }

    return BillResult(
      tipAmount: tip,
      total: total,
      perPerson: total / split,
    );
  }
}
