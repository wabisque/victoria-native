import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'aspirants/aspirant_creation_requests_view.dart';
import 'aspirants/aspirant_update_requests_view.dart';
import 'aspirants/aspirants_view.dart';
import 'aspirants/view_aspirant_creation_request_view.dart';
import 'aspirants/view_aspirant_update_request_view.dart';
import 'aspirants/view_aspirant_view.dart';
import 'constants.dart';
import 'constituencies/add_constituency_view.dart';
import 'constituencies/constituencies_view.dart';
import 'constituencies/edit_constituency_view.dart';
import 'constituencies/view_constituency_view.dart';
import 'dashboard/dashboard_view.dart';
import 'localization/i10n.dart';
import 'localization/localization_provider.dart';
import 'authentication/login_view.dart';
import 'authentication/register_view.dart';
import 'models/aspirant_creation_request_model.dart';
import 'models/aspirant_model.dart';
import 'models/aspirant_update_request_model.dart';
import 'models/constituency_model.dart';
import 'models/party_model.dart';
import 'models/position_model.dart';
import 'models/post_model.dart';
import 'models/region_model.dart';
import 'parties/add_party_view.dart';
import 'parties/edit_party_view.dart';
import 'parties/parties_view.dart';
import 'parties/view_party_view.dart';
import 'positions/add_position_view.dart';
import 'positions/edit_position_view.dart';
import 'positions/positions_view.dart';
import 'positions/view_position_view.dart';
import 'posts/add_post_view.dart';
import 'posts/edit_post_view.dart';
import 'posts/view_post_view.dart';
import 'regions/add_region_view.dart';
import 'regions/edit_region_view.dart';
import 'regions/regions_view.dart';
import 'regions/view_region_view.dart';
import 'settings/aspirant_profile_view.dart';
import 'settings/become_an_aspirant_view.dart';
import 'settings/password_view.dart';
import 'settings/settings_view.dart';
import 'settings/user_profile_view.dart';
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
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.5)
              )
            )
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.5)
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
                AddConstituencyView.routeName => const AddConstituencyView(),
                AddPartyView.routeName => const AddPartyView(),
                AddPositionView.routeName => const AddPositionView(),
                AddPostView.routeName => const AddPostView(),
                AddRegionView.routeName => const AddRegionView(),
                AspirantCreationRequestsView.routeName => const AspirantCreationRequestsView(),
                AspirantProfileView.routeName => const AspirantProfileView(),
                AspirantUpdateRequestsView.routeName => const AspirantUpdateRequestsView(),
                AspirantsView.routeName => const AspirantsView(),
                BecomeAnAspirantView.routeName => const BecomeAnAspirantView(),
                EditConstituencyView.routeName => EditConstituencyView(
                  constituency: ConstituencyModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                EditPartyView.routeName => EditPartyView(
                  party: PartyModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                EditPositionView.routeName => EditPositionView(
                  position: PositionModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                EditPostView.routeName => EditPostView(
                  post: PostModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                EditRegionView.routeName => EditRegionView(
                  region: RegionModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                ConstituenciesView.routeName => const ConstituenciesView(),
                DashboardView.routeName => const DashboardView(),
                LoginView.routeName => const LoginView(),
                PartiesView.routeName => const PartiesView(),
                PasswordView.routeName => const PasswordView(),
                PositionsView.routeName => const PositionsView(),
                RegionsView.routeName => const RegionsView(),
                RegisterView.routeName => const RegisterView(),
                SettingsView.routeName => const SettingsView(),
                UserProfileView.routeName => const UserProfileView(),
                ViewAspirantCreationRequestView.routeName => ViewAspirantCreationRequestView(
                  aspirantCreationRequests: AspirantCreationRequestModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                ViewAspirantUpdateRequestView.routeName => ViewAspirantUpdateRequestView(
                  aspirantUpdateRequest: AspirantUpdateRequestModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                ViewAspirantView.routeName => ViewAspirantView(
                  aspirant: AspirantModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                ViewConstituencyView.routeName => ViewConstituencyView(
                  constituency: ConstituencyModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                ViewPartyView.routeName => ViewPartyView(
                  party: PartyModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                ViewPositionView.routeName => ViewPositionView(
                  position: PositionModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                ViewPostView.routeName => ViewPostView(
                  post: PostModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                ViewRegionView.routeName => ViewRegionView(
                  region: RegionModel.fromJson(routeSettings.arguments as Map<String, dynamic>)
                ),
                _ => const SplashView()
              },
            );
          },
          navigatorObservers: [
            Constants.routeObserver
          ],
        );
      },
    );
  }
}
