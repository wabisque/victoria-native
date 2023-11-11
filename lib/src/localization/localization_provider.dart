import 'package:flutter/material.dart';

import '../provider.dart';
import 'localization_service.dart';

class LocalizationProvider extends Provider {
  final LocalizationService _localizationService;

  LocalizationProvider(this._localizationService);

  Locale get locale => _localizationService.locale;

  Future<void> updateLocale(Locale? locale) async {
    if(locale == null) return;

    await _localizationService.setLocale(locale);
    notifyListeners();
  }
}
