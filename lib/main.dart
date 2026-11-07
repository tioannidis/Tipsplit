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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calculator.dart';

void main() {
  runApp(const TipsplitApp());
}

class TipsplitApp extends StatelessWidget {
  const TipsplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tipsplit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF667EEA)),
        scaffoldBackgroundColor: const Color(0xFF764BA2),
      ),
      home: const TipsplitHomePage(),
    );
  }
}

class TipsplitHomePage extends StatefulWidget {
  const TipsplitHomePage({super.key});

  @override
  State<TipsplitHomePage> createState() => _TipsplitHomePageState();
}

class _TipsplitHomePageState extends State<TipsplitHomePage> {
  static const _presetTips = [10, 15, 18, 20, 25];

  final _billController = TextEditingController();
  final _customTipController = TextEditingController();
  final _peopleController = TextEditingController(text: '1');

  int _selectedTip = 15;
  bool _isCustomTip = false;
  bool _roundedUp = false;

  double get _bill => double.tryParse(_billController.text) ?? 0.0;
  int get _people {
    final parsed = int.tryParse(_peopleController.text) ?? 1;
    return parsed < 1 ? 1 : parsed;
  }

  double get _tipPercent {
    if (!_isCustomTip) return _selectedTip.toDouble();
    return double.tryParse(_customTipController.text) ?? 0.0;
  }

  TipResult get _result => calculateTip(
        bill: _bill,
        tipPercent: _tipPercent,
        people: _people,
        roundUp: _roundedUp,
      );

  @override
  void dispose() {
    _billController.dispose();
    _customTipController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  void _recalculate({bool roundUp = false}) {
    setState(() => _roundedUp = roundUp);
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tipsplit',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _billController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Bill Amount',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _recalculate(),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tip in _presetTips)
                      ChoiceChip(
                        label: Text('$tip%'),
                        selected: !_isCustomTip && _selectedTip == tip,
                        onSelected: (_) => setState(() {
                          _isCustomTip = false;
                          _selectedTip = tip;
                          _roundedUp = false;
                        }),
                      ),
                    ChoiceChip(
                      label: const Text('Custom'),
                      selected: _isCustomTip,
                      onSelected: (_) => setState(() {
                        _isCustomTip = true;
                        _roundedUp = false;
                      }),
                    ),
                  ],
                ),
                if (_isCustomTip) ...[
                  const SizedBox(height: 20),
                  TextField(
                    controller: _customTipController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Custom Tip %',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _recalculate(),
                  ),
                ],
                const SizedBox(height: 20),
                TextField(
                  controller: _peopleController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Number of People',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _recalculate(),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed:
                      _bill > 0 ? () => _recalculate(roundUp: true) : null,
                  child: const Text('Round Up to Next Dollar'),
                ),
                const SizedBox(height: 24),
                _ResultCard(
                  tipAmount: result.tipAmount,
                  totalAmount: result.totalAmount,
                  perPerson: result.perPerson,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.tipAmount,
    required this.totalAmount,
    required this.perPerson,
  });

  final double tipAmount;
  final double totalAmount;
  final double perPerson;

  static String _format(double value) =>
      NumberFormat.currency(symbol: '\$').format(value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _ResultRow(label: 'Tip Amount', value: _format(tipAmount)),
          _ResultRow(label: 'Total Amount', value: _format(totalAmount)),
          _ResultRow(
              label: 'Per Person',
              value: _format(perPerson),
              emphasized: true),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: emphasized
                ? theme.textTheme.titleMedium
                : theme.textTheme.bodyLarge,
          ),
          Text(
            value,
            style: (emphasized
                    ? theme.textTheme.titleMedium
                    : theme.textTheme.bodyLarge)
                ?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
