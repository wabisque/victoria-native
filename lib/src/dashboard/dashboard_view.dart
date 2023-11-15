import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../settings/settings_view.dart';
import 'actions_tab_view.dart';
import 'aspirants_tab_view.dart';
import 'posts_tab_view.dart';

class DashboardView extends StatefulWidget {
  static const String routeName = '/dashboard';

  const DashboardView({
    super.key
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final AuthenticationProvider authenticationProvider = context.watch<AuthenticationProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                navigatorState.restorablePushNamed(SettingsView.routeName);
              },
              icon: const Icon(Icons.settings)
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.menu)
              ),
              Tab(
                icon: Icon(Icons.notifications)
              )
            ],
          ),
          title: Text(appLocalizations.dashboardViewTitle),
        ),
        body: TabBarView(
          children: [
            switch(authenticationProvider.user!.role!.name) {
              'Follower' => const AspirantsTabView(),
              _ => const ActionsTabView()
            },
            const PostsTabView()
          ],
        )
      )
    );
  }
}
