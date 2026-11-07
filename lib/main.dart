import 'package:flutter/material.dart';

import 'calculator.dart';

const _quickTips = [10.0, 15.0, 18.0, 20.0, 25.0];

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
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.dark,
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
  final _calculator = const TipCalculator();
  final _billController = TextEditingController();
  final _customTipController = TextEditingController();

  double _tipPercent = 15.0;
  int _people = 1;
  bool _roundUp = false;

  double get _billAmount => _calculator.parseAmount(_billController.text);

  double get _effectiveTipPercent {
    if (_quickTips.contains(_tipPercent)) {
      return _tipPercent;
    }
    final custom = _calculator.parseAmount(_customTipController.text);
    return custom;
  }

  BillResult get _result => _calculator.calculate(
        billAmount: _billAmount,
        tipPercent: _effectiveTipPercent,
        people: _people,
        roundUp: _roundUp,
      );

  @override
  void dispose() {
    _billController.dispose();
    _customTipController.dispose();
    super.dispose();
  }

  void _selectQuickTip(double percent) {
    setState(() {
      _tipPercent = percent;
      _customTipController.clear();
    });
  }

  void _useCustomTip() {
    setState(() {
      _tipPercent = _calculator.parseAmount(_customTipController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipsplit'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _billController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Bill amount',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Text('Tip percentage', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickTips
                  .map((percent) => ChoiceChip(
                        label: Text('${percent.toStringAsFixed(0)}%'),
                        selected: _tipPercent == percent &&
                            _customTipController.text.isEmpty,
                        onSelected: (_) => _selectQuickTip(percent),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _customTipController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Custom tip percentage',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _useCustomTip(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Split between', style: theme.textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _people > 1
                      ? () => setState(() => _people -= 1)
                      : null,
                ),
                Text(
                  '$_people',
                  style: theme.textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _people += 1),
                ),
                const Text('people'),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Round up total'),
              subtitle: const Text('Round to the nearest dollar'),
              value: _roundUp,
              onChanged: (value) => setState(() => _roundUp = value),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ResultRow(
                      label: 'Tip amount',
                      value: result.tipAmount,
                    ),
                    const Divider(),
                    _ResultRow(
                      label: 'Total',
                      value: result.total,
                      emphasize: true,
                    ),
                    const Divider(),
                    _ResultRow(
                      label: 'Per person ($_people)',
                      value: result.perPerson,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final double value;
  final bool emphasize;

  const _ResultRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasize
        ? theme.textTheme.headlineMedium
        : theme.textTheme.titleLarge;

    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.titleMedium)),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: style?.copyWith(
            color: emphasize ? theme.colorScheme.primary : null,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
