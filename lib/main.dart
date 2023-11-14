import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app.dart';
import 'src/authentication/authentication_provider.dart';
import 'src/authentication/authentication_service.dart';
import 'src/localization/i10n.dart';
import 'src/localization/localization_provider.dart';
import 'src/localization/localization_service.dart';
import 'src/preferences.dart';
import 'src/theme/theme_provider.dart';
import 'src/theme/theme_service.dart';

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  Preferences.instance = await SharedPreferences.getInstance();

  // await Preferences.instance.clear();

  final bool isSetup = Preferences.instance.getBool('isSetup') ?? false;

  if(isSetup) return;

  await Future.wait<void>([
    Preferences.instance.setString(
      'authentication:token',
      ''
    ),
    Preferences.instance.setString(
      'localization:locale',
      I10n.en.locale.languageCode
    ),
    Preferences.instance.setString(
      'theme:themeMode',
      'system'
    ),
    Preferences.instance.setBool(
      'isSetup',
      true
    )
  ]);
}

void main() async {
  await _setup();
  
  final AuthenticationProvider authenticationProvider = AuthenticationProvider(AuthenticationService());
  final LocalizationProvider localizationProvider = LocalizationProvider(LocalizationService());
  final ThemeProvider themeProvider = ThemeProvider(ThemeService());

  await Future.wait([
    authenticationProvider.init()
  ]);

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext context) => authenticationProvider
        ),
        ChangeNotifierProvider<LocalizationProvider>(
          create: (BuildContext context) => localizationProvider
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (BuildContext context) => themeProvider
        )
      ],
      child: const App()
    )
  );
}
