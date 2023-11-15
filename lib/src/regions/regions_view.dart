import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/region_model.dart';
import 'add_region_view.dart';
import 'view_region_view.dart';

class RegionsView extends StatefulWidget {
  static const String routeName = '/regions';
  
  const RegionsView({
    super.key
  });

  @override
  State<RegionsView> createState() => _RegionsViewState();
}

class _RegionsViewState extends State<RegionsView> with RouteAware {
  late List<RegionModel> _regions;

  Future<void> _getRegions() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    final http.Response response = await http.get(
      Uri.parse('${Constants.apiHost}/api/regions'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authenticationProvider.token}',
        'X-Requested-With': 'XMLHttpRequest'
      }
    );
    
    if(response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        _regions = (data['regions']! as List).map((region) => RegionModel.fromJson(region)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.regionsViewTitle)
      ),
      body: RefreshIndicator(
        onRefresh: _getRegions,
        child: _regions.isNotEmpty ? ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 21.0
          ),
          itemBuilder: (BuildContext context, int index) => ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(
                ViewRegionView.routeName,
                arguments: _regions[index].asJson
              );
            },
            title: Text(_regions[index].name)
          ),
          itemCount: _regions.length,
        ) : Center(
          child: Text(appLocalizations.regionsViewEmptyText)
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigatorState.restorablePushNamed(AddRegionView.routeName);
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
    _getRegions();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _regions = [];

    _getRegions();
  }
}
