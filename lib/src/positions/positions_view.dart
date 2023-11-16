import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/position_model.dart';
import 'add_position_view.dart';
import 'view_position_view.dart';

class PositionsView extends StatefulWidget {
  static const String routeName = '/positions';
  
  const PositionsView({
    super.key
  });

  @override
  State<PositionsView> createState() => _PositionsViewState();
}

class _PositionsViewState extends State<PositionsView> with RouteAware {
  late List<PositionModel> _positions;
  
  Future<void> _getPositions() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiHost}/api/positions'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authenticationProvider.token}',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      
      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _positions = (data['positions']! as List).map((position) => PositionModel.fromJson(position)).toList();
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
        title: Text(appLocalizations.positionsViewTitle)
      ),
      body: RefreshIndicator(
        onRefresh: _getPositions,
        child: _positions.isNotEmpty ? ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 21.0
          ),
          itemBuilder: (BuildContext context, int index) => ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(
                ViewPositionView.routeName,
                arguments: _positions[index].asJson
              );
            },
            title: Text(_positions[index].name)
          ),
          itemCount: _positions.length,
        ) : Stack(
          children: [
            Center(
              child: Text(appLocalizations.positionsViewEmptyText)
            ),
            ListView()
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigatorState.restorablePushNamed(AddPositionView.routeName);
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
    _getPositions();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _positions = [];

    _getPositions();
  }
}
