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

import 'package:flutter_test/flutter_test.dart';
import 'package:tipsplit/calculator.dart';

void main() {
  group('calculateTip', () {
    test('basic tip calculation', () {
      final result = calculateTip(bill: 25.50, tipPercent: 15, people: 1);
      expect(result.tipAmount, closeTo(3.825, 0.001));
      expect(result.totalAmount, closeTo(29.325, 0.001));
      expect(result.perPerson, closeTo(29.325, 0.001));
    });

    test('splits across multiple people', () {
      final result = calculateTip(bill: 100, tipPercent: 20, people: 4);
      expect(result.tipAmount, closeTo(20, 0.001));
      expect(result.totalAmount, closeTo(120, 0.001));
      expect(result.perPerson, closeTo(30, 0.001));
    });

    test('round up adjusts tip to next whole dollar', () {
      final result = calculateTip(
          bill: 25.50, tipPercent: 15, people: 1, roundUp: true);
      expect(result.totalAmount, 30);
      expect(result.tipAmount, closeTo(4.50, 0.001));
      expect(result.perPerson, 30);
    });

    test('round up with multiple people', () {
      final result = calculateTip(
          bill: 41.30, tipPercent: 18, people: 3, roundUp: true);
      expect(result.totalAmount, 49);
      expect(result.tipAmount, closeTo(7.70, 0.001));
      expect(result.perPerson, closeTo(16.3333, 0.001));
    });

    test('zero bill yields zero results', () {
      final result = calculateTip(bill: 0, tipPercent: 15, people: 2);
      expect(result.tipAmount, 0);
      expect(result.totalAmount, 0);
      expect(result.perPerson, 0);
    });

    test('zero tip percent is allowed', () {
      final result = calculateTip(bill: 10, tipPercent: 0, people: 1);
      expect(result.tipAmount, 0);
      expect(result.totalAmount, 10);
    });

    test('negative inputs are clamped safely', () {
      final result = calculateTip(bill: -5, tipPercent: -10, people: 0);
      expect(result.tipAmount, 0);
      expect(result.totalAmount, 0);
      expect(result.perPerson, 0);
    });

    test('round up on zero bill does nothing', () {
      final result = calculateTip(
          bill: 0, tipPercent: 15, people: 1, roundUp: true);
      expect(result.totalAmount, 0);
    });
  });
}
