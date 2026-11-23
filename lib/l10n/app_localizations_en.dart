// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tipsplit - Tip Calculator';

  @override
  String get appName => 'Tipsplit';

  @override
  String get billAmountLabel => 'Bill Amount (\$)';

  @override
  String get tipPercentLabel => 'Tip %';

  @override
  String get customTipLabel => 'Custom Tip %';

  @override
  String get customButton => 'Custom';

  @override
  String get numberOfPeopleLabel => 'Number of People';

  @override
  String get roundUpButton => 'Round Up to Next Dollar';

  @override
  String get tipAmountLabel => 'Tip Amount:';

  @override
  String get totalAmountLabel => 'Total Amount:';

  @override
  String get perPersonLabel => 'Per Person:';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'German';

  @override
  String get defaultTipLabel => 'Default Tip';

  @override
  String get languageSubtitle => 'Choose the app language';

  @override
  String get defaultTipSubtitle => 'Preset applied when the app starts';
}
