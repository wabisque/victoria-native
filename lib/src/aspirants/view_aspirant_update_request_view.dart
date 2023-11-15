import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../constituencies/view_constituency_view.dart';
import '../models/aspirant_update_request_model.dart';
import '../parties/view_party_view.dart';
import '../positions/view_position_view.dart';

class ViewAspirantUpdateRequestView extends StatefulWidget {
  static const String routeName = '/aspirants/update-requests/view';

  final AspirantUpdateRequestModel aspirantUpdateRequest;

  const ViewAspirantUpdateRequestView({
    super.key,
    required this.aspirantUpdateRequest
  });

  @override
  State<ViewAspirantUpdateRequestView> createState() => _ViewAspirantUpdateRequestViewState();
}

class _ViewAspirantUpdateRequestViewState extends State<ViewAspirantUpdateRequestView> with RouteAware {
  late AspirantUpdateRequestModel _aspirantUpdateRequest;

  Future<int> _confirmAspirantUpdateRequest(String status) async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    final http.Response response = await http.put(
      Uri.parse('${Constants.apiHost}/api/aspirants/update-requests/${_aspirantUpdateRequest.id}'),
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

  Future<void> _getAspirantUpdateRequest() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    final http.Response response = await http.get(
      Uri.parse('${Constants.apiHost}/api/aspirants/update-requests/${widget.aspirantUpdateRequest.id}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authenticationProvider.token}',
        'X-Requested-With': 'XMLHttpRequest'
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        _aspirantUpdateRequest = AspirantUpdateRequestModel.fromJson(data['aspirant_update_request']);
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
        title: Text(appLocalizations.viewAspirantUpdateRequestViewTitle),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text(appLocalizations.viewAspirantUpdateRequestViewConfirmModalText),
                  title: Text(appLocalizations.viewAspirantUpdateRequestViewConfirmModalTitle),
                  actions: [
                    TextButton(
                      onPressed: () {
                        navigatorState.pop();
                      },
                      child: Text(appLocalizations.viewAspirantUpdateRequestViewConfirmModalCancelActionText)
                    ),
                    TextButton(
                      onPressed: () async {
                        if(await _confirmAspirantUpdateRequest('Declined') == 200) {
                          navigatorState.pop();
                          navigatorState.pop();
                        }
                      },
                      child: Text(appLocalizations.viewAspirantUpdateRequestViewConfirmModalDeclineActionText)
                    ),
                    TextButton(
                      onPressed: () async {
                        if(await _confirmAspirantUpdateRequest('Accepted') == 200) {
                          navigatorState.pop();
                          navigatorState.pop();
                        }
                      },
                      child: Text(appLocalizations.viewAspirantUpdateRequestViewConfirmModalAcceptActionText)
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
        onRefresh: _getAspirantUpdateRequest,
        child: ListView(
          padding: const EdgeInsets.all(21.0),
          children: [
            Text(
              _aspirantUpdateRequest.aspirant!.user!.name,
              style: themeData.textTheme.titleLarge
            ),
            Text(
              _aspirantUpdateRequest.aspirant!.user!.email,
              style: themeData.textTheme.labelLarge
            ),
            Text(
              _aspirantUpdateRequest.aspirant!.user!.phoneNumber,
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
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            navigatorState.restorablePushNamed(
                              ViewPositionView.routeName,
                              arguments: _aspirantUpdateRequest.aspirant!.position!.asJson
                            );
                          },
                          child: Text(_aspirantUpdateRequest.aspirant!.position!.name)
                        ),
                        const Text(' → '),
                        TextButton(
                          onPressed: () {
                            navigatorState.restorablePushNamed(
                              ViewPositionView.routeName,
                              arguments: _aspirantUpdateRequest.position!.asJson
                            );
                          },
                          child: Text(_aspirantUpdateRequest.position!.name)
                        )
                      ],
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
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            navigatorState.restorablePushNamed(
                              ViewPartyView.routeName,
                              arguments: _aspirantUpdateRequest.aspirant!.party!.asJson
                            );
                          },
                          child: Text(_aspirantUpdateRequest.party!.name)
                        ),
                        const Text(' → '),
                        TextButton(
                          onPressed: () {
                            navigatorState.restorablePushNamed(
                              ViewPartyView.routeName,
                              arguments: _aspirantUpdateRequest.party!.asJson
                            );
                          },
                          child: Text(_aspirantUpdateRequest.party!.name)
                        )
                      ]
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
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            navigatorState.restorablePushNamed(
                              ViewConstituencyView.routeName,
                              arguments: _aspirantUpdateRequest.aspirant!.constituency!.asJson
                            );
                          },
                          child: Text('${_aspirantUpdateRequest.constituency!.name} (${_aspirantUpdateRequest.constituency!.region!.name})')
                        ),
                        const Text(' → '),
                        TextButton(
                          onPressed: () {
                            navigatorState.restorablePushNamed(
                              ViewConstituencyView.routeName,
                              arguments: _aspirantUpdateRequest.constituency!.asJson
                            );
                          },
                          child: Text('${_aspirantUpdateRequest.constituency!.name} (${_aspirantUpdateRequest.constituency!.region!.name})')
                        )
                      ]
                    )
                  ]
                )
              ]
            ),
            const SizedBox(
              height: 21.0
            ),
            Text('Created at → ${DateFormat.yMMMMd().add_jms().format(_aspirantUpdateRequest.createdAt)}'),
            Text('Last updated at → ${DateFormat.yMMMMd().add_jms().format(_aspirantUpdateRequest.updatedAt)}')
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
    _getAspirantUpdateRequest();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _aspirantUpdateRequest = widget.aspirantUpdateRequest;

    _getAspirantUpdateRequest();
  }
}
