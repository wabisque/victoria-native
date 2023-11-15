import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../aspirants/aspirant_creation_requests_view.dart';
import '../aspirants/aspirant_update_requests_view.dart';
import '../aspirants/aspirants_view.dart';
import '../authentication/authentication_provider.dart';
import '../constituencies/constituencies_view.dart';
import '../parties/parties_view.dart';
import '../positions/positions_view.dart';
import '../regions/regions_view.dart';

class ActionsTabView extends StatefulWidget {
  const ActionsTabView({
    super.key
  });

  @override
  State<ActionsTabView> createState() => _ActionsTabViewState();
}

class _ActionsTabViewState extends State<ActionsTabView> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final AuthenticationProvider authenticationProvider = context.watch<AuthenticationProvider>();

    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 21.0
      ),
      children: [
        if(authenticationProvider.user!.role!.name == 'Administrator') ...[
          ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(AspirantsView.routeName);
            },
            title: Text(appLocalizations.dashboardActionsTabViewAspirantsActionText)
          ),
          ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(AspirantCreationRequestsView.routeName);
            },
            title: Text(appLocalizations.dashboardActionsTabViewAspirantCreationRequestsActionText)
          ),
          ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(AspirantUpdateRequestsView.routeName);
            },
            title: Text(appLocalizations.dashboardActionsTabViewAspirantUpdateRequestsActionText)
          ),
          const Divider(),
          ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(ConstituenciesView.routeName);
            },
            title: Text(appLocalizations.dashboardActionsTabViewConstituenciesActionText)
          ),
          const Divider(),
          ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(PartiesView.routeName);
            },
            title: Text(appLocalizations.dashboardActionsTabViewPartiesActionText)
          ),
          const Divider(),
          ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(PositionsView.routeName);
            },
            title: Text(appLocalizations.dashboardActionsTabViewPositionsActionText)
          ),
          const Divider(),
          ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(RegionsView.routeName);
            },
            title: Text(appLocalizations.dashboardActionsTabViewRegionsActionText)
          )
        ]
      ]
    );
  }
}
