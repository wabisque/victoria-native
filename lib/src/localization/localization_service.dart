import 'package:flutter/material.dart';

import '../preferences.dart';

class LocalizationService {
  Locale get locale => Locale(Preferences.instance.getString('localization:locale')!);

  Future<void> setLocale(Locale locale) async => await Preferences.instance.setString(
    'localization:locale',
    locale.languageCode
  );
}
