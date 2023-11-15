import 'package:flutter/material.dart';

import '../constants.dart';

class LocalizationService {
  Locale get locale => Locale(Constants.preferences.getString('localization:locale')!);

  Future<void> setLocale(Locale locale) async => await Constants.preferences.setString(
    'localization:locale',
    locale.languageCode
  );
}
