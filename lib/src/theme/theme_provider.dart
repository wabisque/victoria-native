import 'package:flutter/material.dart';

import '../provider.dart';
import 'theme_service.dart';

class ThemeProvider extends Provider {
  final ThemeService _themeService;

  ThemeProvider(this._themeService);

  ThemeMode get themeMode => _themeService.themeMode;

  Future<void> updateThemeMode(ThemeMode? themeMode) async {
    if(themeMode == null) return;

    await _themeService.setThemeMode(themeMode);
    notifyListeners();
  }
}
