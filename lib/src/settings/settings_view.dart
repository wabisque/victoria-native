import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/i10n.dart';
import '../localization/localization_provider.dart';
import '../theme/theme_provider.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({
    super.key
  });

  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final LocalizationProvider localizationProvider = context.watch<LocalizationProvider>();
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: Column(
          children: [
            DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: themeProvider.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: themeProvider.updateThemeMode,
              items: ThemeMode.values.map(
                (ThemeMode themeMode) => DropdownMenuItem(
                  value: themeMode,
                  child: Text(
                    switch(themeMode) {
                      ThemeMode.system => 'System',
                      ThemeMode.dark => 'Dark',
                      _ => 'Light'
                    }
                  ),
                )
              ).toList(),
            ),
            DropdownButton<Locale>(
              // Read the selected themeMode from the controller
              value: localizationProvider.locale,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: localizationProvider.updateLocale,
              items: I10n.values.map(
                (I10n i10n) => DropdownMenuItem(
                  value: i10n.locale,
                  child: Text(i10n.name),
                )
              ).toList(),
            )
          ]
        ),
      ),
    );
  }
}
