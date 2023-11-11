import 'package:flutter/material.dart';

import '../preferences.dart';

class ThemeService {
  ThemeMode get themeMode => switch(Preferences.instance.getString('theme:themeMode')!) {
    'system' => ThemeMode.system,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.light
  };

  Future<void> setThemeMode(ThemeMode themeMode) async => await Preferences.instance.setString(
    'theme:themeMode',
    switch(themeMode) {
      ThemeMode.system => 'system',
      ThemeMode.dark => 'dark',
      _ => 'light'
    }
  );
}
