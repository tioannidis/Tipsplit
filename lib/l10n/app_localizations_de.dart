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
}
