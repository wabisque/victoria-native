import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/constituency_model.dart';
import 'add_constituency_view.dart';
import 'view_constituency_view.dart';

class ConstituenciesView extends StatefulWidget {
  static const String routeName = '/constituencies';
  
  const ConstituenciesView({
    super.key
  });

  @override
  State<ConstituenciesView> createState() => _ConstituenciesViewState();
}

class _ConstituenciesViewState extends State<ConstituenciesView> with RouteAware {
  late List<ConstituencyModel> _constituencies;

  Future<void> _getConstituencies() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    final http.Response response = await http.get(
      Uri.parse('${Constants.apiHost}/api/constituencies'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authenticationProvider.token}',
        'X-Requested-With': 'XMLHttpRequest'
      }
    );
    
    if(response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        _constituencies = (data['constituencies']! as List).map((constituency) => ConstituencyModel.fromJson(constituency)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.constituenciesViewTitle)
      ),
      body: RefreshIndicator(
        onRefresh: _getConstituencies,
        child: _constituencies.isNotEmpty ? ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 21.0
          ),
          itemBuilder: (BuildContext context, int index) => ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(
                ViewConstituencyView.routeName,
                arguments: _constituencies[index].asJson
              );
            },
            subtitle: Text(_constituencies[index].region!.name),
            title: Text(_constituencies[index].name),
          ),
          itemCount: _constituencies.length,
        ) : Center(
          child: Text(appLocalizations.constituenciesViewEmptyText)
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigatorState.restorablePushNamed(AddConstituencyView.routeName);
        },
        child: const Icon(Icons.add)
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
    _getConstituencies();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _constituencies = [];

    _getConstituencies();
  }
}
