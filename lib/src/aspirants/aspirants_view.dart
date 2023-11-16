import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/aspirant_model.dart';
import 'view_aspirant_view.dart';

class AspirantsView extends StatefulWidget {
  static const String routeName = '/aspirants';
  
  const AspirantsView({
    super.key
  });

  @override
  State<AspirantsView> createState() => _AspirantsViewState();
}

class _AspirantsViewState extends State<AspirantsView> with RouteAware {
  late List<AspirantModel> _aspirants;

  Future<void> _getAspirants() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiHost}/api/aspirants'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authenticationProvider.token}',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      
      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _aspirants = (data['aspirants']! as List).map((aspirant) => AspirantModel.fromJson(aspirant)).toList();
        });
      }
    } catch(error) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.aspirantsViewTitle)
      ),
      body: RefreshIndicator(
        onRefresh: _getAspirants,
        child: _aspirants.isNotEmpty ? ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 21.0
          ),
          itemBuilder: (BuildContext context, int index) => ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(
                ViewAspirantView.routeName,
                arguments: _aspirants[index].asJson
              );
            },
            title: Text(_aspirants[index].user!.name),
            subtitle: Text('${_aspirants[index].position!.name} | ${_aspirants[index].party!.name} | ${_aspirants[index].constituency!.name} (${_aspirants[index].constituency!.region!.name})'),
          ),
          itemCount: _aspirants.length,
        ) : Stack(
          children: [
            Center(
              child: Text(appLocalizations.aspirantsViewEmptyText)
            ),
            ListView()
          ]
        )
      )
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final PageRoute pageRoute = ModalRoute.of(context) as PageRoute;

    Constants.routeObserver.subscribe(
      this,
      pageRoute
    );
  }

  @override
  void didPopNext() {
    _getAspirants();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _aspirants = [];

    _getAspirants();
  }
}
