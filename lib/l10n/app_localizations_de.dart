// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Tipsplit - Trinkgeldrechner';

  @override
  String get appName => 'Tipsplit';

  @override
  String get billAmountLabel => 'Rechnungsbetrag (\$)';

  @override
  String get tipPercentLabel => 'Trinkgeld %';

  @override
  String get customTipLabel => 'Individuelles Trinkgeld %';

  @override
  String get customButton => 'Individuell';

  @override
  String get numberOfPeopleLabel => 'Anzahl Personen';

  @override
  String get roundUpButton => 'Auf nächsten Dollar aufrunden';

  @override
  String get tipAmountLabel => 'Trinkgeld:';

  @override
  String get totalAmountLabel => 'Gesamt:';

  @override
  String get perPersonLabel => 'Pro Person:';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get languageSystem => 'Systemvorgabe';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get defaultTipLabel => 'Standard-Trinkgeld';

  @override
  String get languageSubtitle => 'Wähle die App-Sprache';

  @override
  String get defaultTipSubtitle => 'Voreinstellung beim Start der App';
}
