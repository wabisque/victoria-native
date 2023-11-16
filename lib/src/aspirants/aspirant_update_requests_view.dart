import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/aspirant_update_request_model.dart';
import 'view_aspirant_update_request_view.dart';

class AspirantUpdateRequestsView extends StatefulWidget {
  static const String routeName = '/aspirants/update-requests';
  
  const AspirantUpdateRequestsView({
    super.key
  });

  @override
  State<AspirantUpdateRequestsView> createState() => _AspirantUpdateRequestsViewState();
}

class _AspirantUpdateRequestsViewState extends State<AspirantUpdateRequestsView> with RouteAware {
  late List<AspirantUpdateRequestModel> _aspirantUpdateRequests;

  Future<void> _getAspirantUpdateRequests() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiHost}/api/aspirants/update-requests'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authenticationProvider.token}',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      
      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _aspirantUpdateRequests = (data['aspirant_update_requests']! as List).map((aspirantUpdateRequest) => AspirantUpdateRequestModel.fromJson(aspirantUpdateRequest)).toList();
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
        title: Text(appLocalizations.aspirantsTitle)
      ),
      body: RefreshIndicator(
        onRefresh: _getAspirantUpdateRequests,
        child: _aspirantUpdateRequests.isNotEmpty ? ListView.builder(
          padding: const EdgeInsets.all(21.0),
          itemBuilder: (BuildContext context, int index) => ListTile(
            onTap: () {
              navigatorState.restorablePushNamed(
                ViewAspirantUpdateRequestView.routeName,
                arguments: _aspirantUpdateRequests[index].asJson
              );
            },
            title: Text(_aspirantUpdateRequests[index].aspirant!.user!.name),
            subtitle: Text('${_aspirantUpdateRequests[index].aspirant!.position!.name} → ${_aspirantUpdateRequests[index].position!.name} | ${_aspirantUpdateRequests[index].aspirant!.party!.name} → ${_aspirantUpdateRequests[index].party!.name} | ${_aspirantUpdateRequests[index].aspirant!.constituency!.name} (${_aspirantUpdateRequests[index].aspirant!.constituency!.region!.name}) → ${_aspirantUpdateRequests[index].constituency!.name} (${_aspirantUpdateRequests[index].constituency!.region!.name})'),
          ),
          itemCount: _aspirantUpdateRequests.length,
        ) : Stack(
          children: [
            Center(
              child: Text(appLocalizations.noAspirantUpdateRequestsToShowPrompt)
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
    _getAspirantUpdateRequests();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _aspirantUpdateRequests = [];

    _getAspirantUpdateRequests();
  }
}
