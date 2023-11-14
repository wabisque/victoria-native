import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'dashboard/dashboard_view.dart';
import 'localization/i10n.dart';
import 'localization/localization_provider.dart';
import 'authentication/login_view.dart';
import 'authentication/register_view.dart';
import 'settings/settings_view.dart';
import 'splash/splash_view.dart';
import 'theme/theme_provider.dart';

/// The Widget that configures your application.
class App extends StatelessWidget {
  const App({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final LocalizationProvider localizationProvider = context.watch<LocalizationProvider>();
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();

    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: Listenable.merge([
        themeProvider
      ]),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: I10n.values.map((I10n i10n) => i10n.locale),
          locale: localizationProvider.locale,

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.title,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
            brightness: Brightness.light,
            colorSchemeSeed: Colors.deepPurple,
            useMaterial3: true,
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.5)
              )
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                height: 1.5
              ),
              bodyMedium: TextStyle(
                fontSize: 14.0,
                height: 1.5
              ),
              titleLarge: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                height: 1.5
              )
            )
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.deepPurple,
            useMaterial3: true,
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.5)
              )
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                height: 1.5
              ),
              bodyMedium: TextStyle(
                fontSize: 14.0,
                height: 1.5
              ),
              titleLarge: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                height: 1.5
              )
            )
          ),
          themeMode: themeProvider.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) => switch (routeSettings.name) {
                DashboardView.routeName => const DashboardView(),
                LoginView.routeName => const LoginView(),
                RegisterView.routeName => const RegisterView(),
                SettingsView.routeName => const SettingsView(),
                _ => const SplashView()
              },
            );
          },
        );
      },
    );
  }
}
