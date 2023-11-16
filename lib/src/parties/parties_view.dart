import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/party_model.dart';
import 'add_party_view.dart';
import 'view_party_view.dart';

class PartiesView extends StatefulWidget {
  static const String routeName = '/parties';
  
  const PartiesView({
    super.key
  });

  @override
  State<PartiesView> createState() => _PartiesViewState();
}

class _PartiesViewState extends State<PartiesView> with RouteAware {
  late List<PartyModel> _parties;

  Future<void> _getParties() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiHost}/api/parties'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authenticationProvider.token}',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      
      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _parties = (data['parties']! as List).map((party) => PartyModel.fromJson(party)).toList();
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
        title: Text(appLocalizations.partiesTitle)
      ),
      body: RefreshIndicator(
        onRefresh: _getParties,
        child: _parties.isNotEmpty ? ListView.builder(
          itemBuilder: (BuildContext context, int index) => ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(
                ViewPartyView.routeName,
                arguments: _parties[index].asJson
              );
            },
            title: Text(_parties[index].name)
          ),
          itemCount: _parties.length,
        ) : Stack(
          children: [
            Center(
              child: Text(appLocalizations.noPartiesToShowPrompt)
            ),
            ListView()
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigatorState.restorablePushNamed(AddPartyView.routeName);
        },
        child: const Icon(Icons.add_outlined)
      ),
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
    _getParties();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _parties = [];

    _getParties();
  }
}
