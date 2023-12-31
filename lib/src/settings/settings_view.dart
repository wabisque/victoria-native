import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../authentication/login_view.dart';
import '../localization/i10n.dart';
import '../localization/localization_provider.dart';
import '../theme/theme_provider.dart';
import 'aspirant_profile_view.dart';
import 'become_an_aspirant_view.dart';
import 'password_view.dart';
import 'user_profile_view.dart';

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
        title: Text(appLocalizations.settingsTitle)
      ),
      body: ListView(
        padding: const EdgeInsets.all(21.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person_outlined),
            onTap: () {
              navigatorState.restorablePushNamed(UserProfileView.routeName);
            },
            title: Text(appLocalizations.userProfileTitle),
          ),
          ListTile(
            leading: const Icon(Icons.key_outlined),
            onTap: () {
              navigatorState.restorablePushNamed(PasswordView.routeName);
            },
            title: Text(appLocalizations.changePasswordTitle),
          ),
          if(authenticationProvider.user?.role?.name != 'Administrator') ...[
            const Divider(),
            Badge(
              isLabelVisible: (authenticationProvider.user?.hasAspirantCreationRequest ?? false) || (authenticationProvider.user?.hasAspirantUpdateRequest ?? false),
              child: ListTile(
                leading: const Icon(Icons.supervised_user_circle_outlined),
                onTap: () {
                  if(authenticationProvider.user?.role?.name == 'Aspirant') {
                    navigatorState.restorablePushNamed(AspirantProfileView.routeName);
                  } else {
                    navigatorState.restorablePushNamed(BecomeAnAspirantView.routeName);
                  }
                },
                title: Text(authenticationProvider.user?.role?.name == 'Aspirant' ? appLocalizations.aspirantProfileTitle : appLocalizations.becomeAnAspirantTitle)
              )
            )
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => ListView.builder(
                  padding: const EdgeInsets.all(21.0),
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    onTap: () async {
                      await themeProvider.updateThemeMode(ThemeMode.values[index]);
                      navigatorState.pop();
                    },
                    selected: ThemeMode.values[index] == themeProvider.themeMode,
                    title: Text(
                      switch(ThemeMode.values[index]) {
                        ThemeMode.dark => appLocalizations.darkPrompt,
                        ThemeMode.system => appLocalizations.systemPrompt,
                        _ => appLocalizations.lightPromt
                      }
                    )
                  ),
                  itemCount: ThemeMode.values.length
                )
              );
            },
            title: Text(appLocalizations.themeModeAction),
          ),
          ListTile(
            leading: const Icon(Icons.translate_outlined),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => ListView.builder(
                  padding: const EdgeInsets.all(21.0),
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    onTap: () async {
                      await localizationProvider.updateLocale(I10n.values[index].locale);
                      navigatorState.pop();
                    },
                    selected: I10n.values[index].locale == localizationProvider.locale,
                    title: Text(I10n.values[index].name)
                  ),
                  itemCount: I10n.values.length
                )
              );
            },
            title: Text(appLocalizations.languageAction),
          ),
          const Divider(),
          ListTile(
            hoverColor: themeData.colorScheme.error.withOpacity(0.075),
            iconColor: themeData.colorScheme.error,
            leading: const Icon(Icons.logout_outlined),
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
            title: Text(appLocalizations.logoutAction)
          )
        ],
      )
    );
  }
}
