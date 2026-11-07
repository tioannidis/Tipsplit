// Tipsplit - a simple tip calculator with split and round-up support.
// Copyright (C) 2025  Tipsplit contributors
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

class TipResult {
  const TipResult({
    required this.tipAmount,
    required this.totalAmount,
    required this.perPerson,
  });

  final double tipAmount;
  final double totalAmount;
  final double perPerson;
}

TipResult calculateTip({
  required double bill,
  required double tipPercent,
  required int people,
  bool roundUp = false,
}) {
  final safeBill = bill < 0 ? 0.0 : bill;
  final safeTipPercent = tipPercent < 0 ? 0.0 : tipPercent;
  final safePeople = people < 1 ? 1 : people;

  final tipAmount = (safeBill * safeTipPercent) / 100;
  final totalAmount = safeBill + tipAmount;

  if (roundUp && safeBill > 0) {
    final roundedTotal = totalAmount.ceilToDouble();
    final roundedTip = roundedTotal - safeBill;
    return TipResult(
      tipAmount: roundedTip,
      totalAmount: roundedTotal,
      perPerson: roundedTotal / safePeople,
    );
  }

  return TipResult(
    tipAmount: tipAmount,
    totalAmount: totalAmount,
    perPerson: totalAmount / safePeople,
  );
}
