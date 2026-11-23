import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'calculator.dart';
import 'settings.dart';
import 'l10n/app_localizations.dart';

const _kGradientStart = Color(0xFF667EEA);
const _kGradientEnd = Color(0xFF764BA2);
const _kCardBackground = Color(0xFFFFFFFF);
const _kTitleColor = Color(0xFF333333);
const _kLabelColor = Color(0xFF666666);
const _kBorderColor = Color(0xFFE1E5E9);
const _kInputBackground = Color(0xFFF8F9FA);
const _kRoundButtonColor = Color(0xFF28A745);

const _kQuickTips = [10.0, 15.0, 18.0, 20.0, 25.0];

void main() {
  runApp(const TipsplitApp());
}

class TipsplitApp extends StatefulWidget {
  const TipsplitApp({super.key, this.locale});

  final Locale? locale;

  @override
  State<TipsplitApp> createState() => _TipsplitAppState();
}

class _TipsplitAppState extends State<TipsplitApp> {
  final _settings = Settings();

  @override
  void initState() {
    super.initState();
    _settings.addListener(_onSettingsChanged);
    _settings.load();
  }

  void _onSettingsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      locale: widget.locale ?? _settings.resolvedLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: _kGradientStart,
      ),
      home: TipsplitHomePage(settings: _settings),
    );
  }
}

class TipsplitHomePage extends StatefulWidget {
  const TipsplitHomePage({
    super.key,
    required this.settings,
  });

  final Settings settings;

  @override
  State<TipsplitHomePage> createState() => _TipsplitHomePageState();
}

class _TipsplitHomePageState extends State<TipsplitHomePage> {
  final _calculator = const TipCalculator();
  final _billController = TextEditingController();
  final _customTipController = TextEditingController();
  final _peopleController = TextEditingController(text: '1');

  double _currentTipPercent = 15.0;
  bool _isCustomTip = false;
  bool _isRounded = false;

  @override
  void initState() {
    super.initState();
    _currentTipPercent = widget.settings.defaultTipPercent;
    widget.settings.addListener(_onSettingsChanged);
  }

  @override
  void didUpdateWidget(TipsplitHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.settings != oldWidget.settings) {
      oldWidget.settings.removeListener(_onSettingsChanged);
      widget.settings.addListener(_onSettingsChanged);
    }
    _onSettingsChanged();
  }

  void _onSettingsChanged() {
    if (!mounted) {
      return;
    }
    setState(() {
      _currentTipPercent = widget.settings.defaultTipPercent;
      _isCustomTip = false;
    });
  }

  double get _billAmount => _calculator.parseAmount(_billController.text);

  int get _people => _calculator.parsePeople(_peopleController.text);

  double get _tipPercent {
    if (_isCustomTip) {
      return _calculator.parseAmount(_customTipController.text);
    }
    return _currentTipPercent;
  }

  BillResult get _result => _calculator.calculate(
        billAmount: _billAmount,
        tipPercent: _tipPercent,
        people: _people,
        roundUp: _isRounded,
      );

  @override
  void dispose() {
    _billController.dispose();
    _customTipController.dispose();
    _peopleController.dispose();
    widget.settings.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onInputChanged() {
    setState(() => _isRounded = false);
  }

  void _selectTip(double percent) {
    setState(() {
      _currentTipPercent = percent;
      _isCustomTip = false;
      _isRounded = false;
    });
  }

  void _selectCustomTip() {
    setState(() {
      _isCustomTip = true;
      _isRounded = false;
    });
  }

  void _roundUp() {
    if (_billAmount == 0) {
      return;
    }
    setState(() => _isRounded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_kGradientStart, _kGradientEnd],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: _kCardBackground,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        const _Header(),
                        Positioned(
                          top: -10,
                          right: -14,
                          child: IconButton(
                            icon: const Icon(Icons.settings),
                            color: _kLabelColor,
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            tooltip:
                                AppLocalizations.of(context)!.settingsTitle,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      SettingsPage(settings: widget.settings),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _InputLabel(
                        text: AppLocalizations.of(context)!.billAmountLabel),
                    const SizedBox(height: 8),
                    _AppTextField(
                      fieldKey: const ValueKey('billField'),
                      controller: _billController,
                      placeholder: '25.50',
                      onChanged: (_) => _onInputChanged(),
                    ),
                    const SizedBox(height: 25),
                    _InputLabel(
                        text: AppLocalizations.of(context)!.tipPercentLabel),
                    const SizedBox(height: 8),
                    _TipGrid(
                      quickTips: _kQuickTips,
                      selectedPercent: _isCustomTip ? null : _currentTipPercent,
                      isCustomSelected: _isCustomTip,
                      onTipSelected: _selectTip,
                      onCustomSelected: _selectCustomTip,
                    ),
                    if (_isCustomTip) ...[
                      const SizedBox(height: 25),
                      _InputLabel(
                          text: AppLocalizations.of(context)!.customTipLabel),
                      const SizedBox(height: 8),
                      _AppTextField(
                        fieldKey: const ValueKey('customTipField'),
                        controller: _customTipController,
                        placeholder: '12',
                        onChanged: (_) => _onInputChanged(),
                      ),
                    ],
                    const SizedBox(height: 25),
                    _InputLabel(
                        text:
                            AppLocalizations.of(context)!.numberOfPeopleLabel),
                    const SizedBox(height: 8),
                    _AppTextField(
                      fieldKey: const ValueKey('peopleField'),
                      controller: _peopleController,
                      placeholder: '1',
                      onChanged: (_) => _onInputChanged(),
                    ),
                    const SizedBox(height: 15),
                    _RoundUpButton(onPressed: _roundUp),
                    const SizedBox(height: 20),
                    _ResultsPanel(result: _result),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('🍽️', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 10),
        Text(
          AppLocalizations.of(context)!.appName,
          style: TextStyle(
            color: _kTitleColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _InputLabel extends StatelessWidget {
  final String text;

  const _InputLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: _kLabelColor,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    );
  }
}

class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String> onChanged;
  final Key? fieldKey;

  const _AppTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.onChanged,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: fieldKey,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      onChanged: onChanged,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hintText: placeholder,
        filled: true,
        fillColor: _kCardBackground,
        contentPadding: const EdgeInsets.all(15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kBorderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kGradientStart, width: 2),
        ),
      ),
    );
  }
}

class _TipGrid extends StatelessWidget {
  final List<double> quickTips;
  final double? selectedPercent;
  final bool isCustomSelected;
  final ValueChanged<double> onTipSelected;
  final VoidCallback onCustomSelected;

  const _TipGrid({
    required this.quickTips,
    required this.selectedPercent,
    required this.isCustomSelected,
    required this.onTipSelected,
    required this.onCustomSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 300 ? 2 : 3;
        final itemCount = quickTips.length + 1;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(itemCount, (index) {
            final width = (constraints.maxWidth - (crossAxisCount - 1) * 10) /
                crossAxisCount;
            if (index < quickTips.length) {
              final tip = quickTips[index];
              return _TipButton(
                label: '${tip.toStringAsFixed(0)}%',
                width: width,
                selected: selectedPercent == tip,
                onPressed: () => onTipSelected(tip),
              );
            }
            return _TipButton(
              label: AppLocalizations.of(context)!.customButton,
              width: width,
              selected: isCustomSelected,
              onPressed: onCustomSelected,
            );
          }),
        );
      },
    );
  }
}

class _TipButton extends StatelessWidget {
  final String label;
  final double width;
  final bool selected;
  final VoidCallback onPressed;

  const _TipButton({
    required this.label,
    required this.width,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: selected ? _kGradientStart : _kCardBackground,
          foregroundColor: selected ? Colors.white : _kTitleColor,
          side: BorderSide(
            color: selected ? _kGradientStart : _kBorderColor,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          textStyle: const TextStyle(fontSize: 16),
        ),
        child: Text(label),
      ),
    );
  }
}

class _RoundUpButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _RoundUpButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _kRoundButtonColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: Text(AppLocalizations.of(context)!.roundUpButton),
    );
  }
}

class _ResultsPanel extends StatelessWidget {
  final BillResult result;

  const _ResultsPanel({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kInputBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _ResultRow(
              label: AppLocalizations.of(context)!.tipAmountLabel,
              value: result.tipAmount),
          const SizedBox(height: 15),
          _ResultRow(
              label: AppLocalizations.of(context)!.totalAmountLabel,
              value: result.total),
          const SizedBox(height: 15),
          Divider(
            height: 2,
            thickness: 2,
            color: _kBorderColor,
          ),
          const SizedBox(height: 15),
          _ResultRow(
            label: AppLocalizations.of(context)!.perPersonLabel,
            value: result.perPerson,
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final double value;
  final bool emphasized;

  const _ResultRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: emphasized ? 18 : 16,
              fontWeight: emphasized ? FontWeight.w600 : FontWeight.w400,
              color: _kTitleColor,
            ),
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: emphasized ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: _kGradientStart,
          ),
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  final Settings settings;

  const SettingsPage({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _kGradientStart,
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: _kGradientStart,
        foregroundColor: Colors.white,
      ),
      body: ListenableBuilder(
        listenable: settings,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SettingTile(
                icon: Icons.language,
                title: l10n.languageLabel,
                subtitle: l10n.languageSubtitle,
                child: DropdownButton<AppLanguage>(
                  value: settings.language,
                  underline: const SizedBox.shrink(),
                  onChanged: (language) {
                    if (language != null) {
                      settings.setLanguage(language);
                    }
                  },
                  items: [
                    for (final language in AppLanguage.values)
                      DropdownMenuItem(
                        value: language,
                        child: Text(
                          switch (language) {
                            AppLanguage.system => l10n.languageSystem,
                            AppLanguage.english => l10n.languageEnglish,
                            AppLanguage.german => l10n.languageGerman,
                          },
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _kGradientStart,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SettingTile(
                icon: Icons.percent,
                title: l10n.defaultTipLabel,
                subtitle: l10n.defaultTipSubtitle,
                child: DropdownButton<double>(
                  value: settings.defaultTipPercent,
                  underline: const SizedBox.shrink(),
                  onChanged: (percent) {
                    if (percent != null) {
                      settings.setDefaultTipPercent(percent);
                    }
                  },
                  items: [
                    for (final percent in _kQuickTips)
                      DropdownMenuItem(
                        value: percent,
                        child: Text(
                          '${percent.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _kGradientStart,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _kCardBackground,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _kGradientStart.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: _kGradientStart, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _kTitleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _kLabelColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            child,
          ],
        ),
      ),
    );
  }
}
