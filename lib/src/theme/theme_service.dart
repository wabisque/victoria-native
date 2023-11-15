import 'package:flutter/material.dart';

import '../constants.dart';

class ThemeService {
  ThemeMode get themeMode => switch(Constants.preferences.getString('theme:themeMode')!) {
    'system' => ThemeMode.system,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.light
  };

  Future<void> setThemeMode(ThemeMode themeMode) async => await Constants.preferences.setString(
    'theme:themeMode',
    switch(themeMode) {
      ThemeMode.system => 'system',
      ThemeMode.dark => 'dark',
      _ => 'light'
    }
  );
}
