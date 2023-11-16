import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/aspirant_creation_request_model.dart';
import 'view_aspirant_creation_request_view.dart';

class AspirantCreationRequestsView extends StatefulWidget {
  static const String routeName = '/aspirants/creation-requests';
  
  const AspirantCreationRequestsView({
    super.key
  });

  @override
  State<AspirantCreationRequestsView> createState() => _AspirantCreationRequestsViewState();
}

class _AspirantCreationRequestsViewState extends State<AspirantCreationRequestsView> with RouteAware {
  late List<AspirantCreationRequestModel> _aspirantCreationRequests;

  Future<void> _getAspirantCreationRequests() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiHost}/api/aspirants/creation-requests'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authenticationProvider.token}',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      
      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _aspirantCreationRequests = (data['aspirant_creation_requests']! as List).map((aspirantCreationRequest) => AspirantCreationRequestModel.fromJson(aspirantCreationRequest)).toList();
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
        title: Text(appLocalizations.aspirantCreationRequestsViewTitle)
      ),
      body: RefreshIndicator(
        onRefresh: _getAspirantCreationRequests,
        child: _aspirantCreationRequests.isNotEmpty ? ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 21.0
          ),
          itemBuilder: (BuildContext context, int index) => ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(
                ViewAspirantCreationRequestView.routeName,
                arguments: _aspirantCreationRequests[index].asJson
              );
            },
            title: Text(_aspirantCreationRequests[index].user!.name),
            subtitle: Text('${_aspirantCreationRequests[index].position!.name} | ${_aspirantCreationRequests[index].party!.name} | ${_aspirantCreationRequests[index].constituency!.name} (${_aspirantCreationRequests[index].constituency!.region!.name})'),
          ),
          itemCount: _aspirantCreationRequests.length,
        ) : Stack(
          children: [
            Center(
              child: Text(appLocalizations.aspirantCreationRequestsViewEmptyText)
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
    _getAspirantCreationRequests();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _aspirantCreationRequests = [];

    _getAspirantCreationRequests();
  }
}
