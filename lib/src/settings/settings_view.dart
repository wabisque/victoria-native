import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../authentication/login_view.dart';
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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final AuthenticationProvider authenticationProvider = context.watch<AuthenticationProvider>();
    final ThemeData themeData = Theme.of(context);
    final LocalizationProvider localizationProvider = context.watch<LocalizationProvider>();
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.settingsViewTitle)
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => ListView.separated(
                  padding: const EdgeInsets.only(
                    top: 14.0
                  ),
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    onTap: () async {
                      await themeProvider.updateThemeMode(ThemeMode.values[index]);
                      navigatorState.pop();
                    },
                    selected: ThemeMode.values[index] == themeProvider.themeMode,
                    title: Text(
                      switch(ThemeMode.values[index]) {
                        ThemeMode.dark => appLocalizations.themeModeDark,
                        ThemeMode.system => appLocalizations.themeModeSystem,
                        _ => appLocalizations.themeModeLight
                      }
                    )
                  ),
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                  itemCount: ThemeMode.values.length
                )
              );
            },
            title: Text(appLocalizations.settingsViewThemeModeActionText),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.translate),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => ListView.separated(
                  padding: const EdgeInsets.only(
                    top: 14.0
                  ),
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    onTap: () async {
                      await localizationProvider.updateLocale(I10n.values[index].locale);
                      navigatorState.pop();
                    },
                    selected: I10n.values[index].locale == localizationProvider.locale,
                    title: Text(I10n.values[index].name)
                  ),
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                  itemCount: I10n.values.length
                )
              );
            },
            title: Text(appLocalizations.settingsViewLanguageActionText),
          ),
          const SizedBox(
            height: 35.0
          ),
          ListTile(
            hoverColor: themeData.colorScheme.error.withOpacity(0.075),
            iconColor: themeData.colorScheme.error,
            leading: const Icon(Icons.logout),
            onTap: () async {
              if(await authenticationProvider.logout() == null) {
                navigatorState.restorablePushNamedAndRemoveUntil(
                  LoginView.routeName,
                  (Route route) => false
                );
              }
            },
            splashColor: themeData.colorScheme.error.withOpacity(0.15),
            textColor: themeData.colorScheme.error,
            title: Text(appLocalizations.settingsViewLogoutActionText)
          )
        ],
      )
    );

    // Padding(
    //     padding: const EdgeInsets.all(16),
    //     // Glue the SettingsController to the theme selection DropdownButton.
    //     //
    //     // When a user selects a theme from the dropdown list, the
    //     // SettingsController is updated, which rebuilds the MaterialApp.
    //     child: Column(
    //       children: [
    //         DropdownButton<ThemeMode>(
    //           // Read the selected themeMode from the controller
    //           value: themeProvider.themeMode,
    //           // Call the updateThemeMode method any time the user selects a theme.
    //           onChanged: themeProvider.updateThemeMode,
    //           items: ThemeMode.values.map(
    //             (ThemeMode themeMode) => DropdownMenuItem(
    //               value: themeMode,
    //               child: Text(
    //                 switch(themeMode) {
    //                   ThemeMode.system => 'System',
    //                   ThemeMode.dark => 'Dark',
    //                   _ => 'Light'
    //                 }
    //               ),
    //             )
    //           ).toList(),
    //         ),
    //         DropdownButton<Locale>(
    //           // Read the selected themeMode from the controller
    //           value: localizationProvider.locale,
    //           // Call the updateThemeMode method any time the user selects a theme.
    //           onChanged: localizationProvider.updateLocale,
    //           items: I10n.values.map(
    //             (I10n i10n) => DropdownMenuItem(
    //               value: i10n.locale,
    //               child: Text(i10n.name),
    //             )
    //           ).toList(),
    //         )
    //       ]
    //     ),
    //   )
  }
}
