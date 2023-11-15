import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../constituencies/view_constituency_view.dart';
import '../models/aspirant_creation_request_model.dart';
import '../parties/view_party_view.dart';
import '../positions/view_position_view.dart';

class ViewAspirantCreationRequestView extends StatefulWidget {
  static const String routeName = '/aspirants/creation-requests/view';

  final AspirantCreationRequestModel aspirantCreationRequests;

  const ViewAspirantCreationRequestView({
    super.key,
    required this.aspirantCreationRequests
  });

  @override
  State<ViewAspirantCreationRequestView> createState() => _ViewAspirantCreationRequestViewState();
}

class _ViewAspirantCreationRequestViewState extends State<ViewAspirantCreationRequestView> with RouteAware {
  late AspirantCreationRequestModel _aspirantCreationRequest;

  Future<int> _confirmAspirantCreationRequest(String status) async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    final http.Response response = await http.put(
      Uri.parse('${Constants.apiHost}/api/aspirants/creation-requests/${_aspirantCreationRequest.id}'),
      body: jsonEncode({
        'status': status
      }),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authenticationProvider.token}',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      }
    );

    return response.statusCode;
  }

  Future<void> _getAspirantCreationRequest() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    final http.Response response = await http.get(
      Uri.parse('${Constants.apiHost}/api/aspirants/creation-requests/${widget.aspirantCreationRequests.id}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authenticationProvider.token}',
        'X-Requested-With': 'XMLHttpRequest'
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        _aspirantCreationRequest = AspirantCreationRequestModel.fromJson(data['aspirant_creation_request']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.viewAspirantCreationRequestViewTitle),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text(appLocalizations.viewAspirantCreationRequestViewConfirmModalText),
                  title: Text(appLocalizations.viewAspirantCreationRequestViewConfirmModalTitle),
                  actions: [
                    TextButton(
                      onPressed: () {
                        navigatorState.pop();
                      },
                      child: Text(appLocalizations.viewAspirantCreationRequestViewConfirmModalCancelActionText)
                    ),
                    TextButton(
                      onPressed: () async {
                        if(await _confirmAspirantCreationRequest('Declined') == 200) {
                          navigatorState.pop();
                          navigatorState.pop();
                        }
                      },
                      child: Text(appLocalizations.viewAspirantCreationRequestViewConfirmModalDeclineActionText)
                    ),
                    TextButton(
                      onPressed: () async {
                        if(await _confirmAspirantCreationRequest('Accepted') == 200) {
                          navigatorState.pop();
                          navigatorState.pop();
                        }
                      },
                      child: Text(appLocalizations.viewAspirantCreationRequestViewConfirmModalAcceptActionText)
                    ),
                  ],
                )
              );
            },
            icon: const Icon(Icons.task_alt)
          )
        ]
      ),
      body: RefreshIndicator(
        onRefresh: _getAspirantCreationRequest,
        child: ListView(
          padding: const EdgeInsets.all(21.0),
          children: [
            Text(
              _aspirantCreationRequest.user!.name,
              style: themeData.textTheme.titleLarge
            ),
            Text(
              _aspirantCreationRequest.user!.email,
              style: themeData.textTheme.labelLarge
            ),
            Text(
              _aspirantCreationRequest.user!.phoneNumber,
              style: themeData.textTheme.labelLarge
            ),
            const SizedBox(
              height: 21.0
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(appLocalizations.viewAspirantViewPositionLabel),
                    const SizedBox(
                      height: 3.5
                    ),
                    TextButton(
                      onPressed: () {
                        navigatorState.restorablePushNamed(
                          ViewPositionView.routeName,
                          arguments: _aspirantCreationRequest.position!.asJson
                        );
                      },
                      child: Text(_aspirantCreationRequest.position!.name)
                    )
                  ]
                ),
                const Divider(),
                Column(
                  children: [
                    Text(appLocalizations.viewAspirantViewPartyLabel),
                    const SizedBox(
                      height: 3.5
                    ),
                    TextButton(
                      onPressed: () {
                        navigatorState.restorablePushNamed(
                          ViewPartyView.routeName,
                          arguments: _aspirantCreationRequest.party!.asJson
                        );
                      },
                      child: Text(_aspirantCreationRequest.party!.name)
                    )
                  ]
                ),
                const Divider(),
                Column(
                  children: [
                    Text(appLocalizations.viewAspirantViewConstituencyLabel),
                    const SizedBox(
                      height: 3.5
                    ),
                    TextButton(
                      onPressed: () {
                        navigatorState.restorablePushNamed(
                          ViewConstituencyView.routeName,
                          arguments: _aspirantCreationRequest.constituency!.asJson
                        );
                      },
                      child: Text('${_aspirantCreationRequest.constituency!.name} (${_aspirantCreationRequest.constituency!.region!.name})')
                    )
                  ]
                )
              ]
            ),
            const SizedBox(
              height: 21.0
            ),
            Text('Created at → ${DateFormat.yMMMMd().add_jms().format(_aspirantCreationRequest.createdAt)}'),
            Text('Last updated at → ${DateFormat.yMMMMd().add_jms().format(_aspirantCreationRequest.updatedAt)}')
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
    _getAspirantCreationRequest();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _aspirantCreationRequest = widget.aspirantCreationRequests;

    _getAspirantCreationRequest();
  }
}
