import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/party_model.dart';
import 'edit_party_view.dart';

class ViewPartyView extends StatefulWidget {
  static const String routeName = '/parties/view';

  final PartyModel party;

  const ViewPartyView({
    super.key,
    required this.party
  });

  @override
  State<ViewPartyView> createState() => _ViewPartyViewState();
}

class _ViewPartyViewState extends State<ViewPartyView> with RouteAware {
  late PartyModel _party;

  Future<void> _getParty() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    final http.Response response = await http.get(
      Uri.parse('${Constants.apiHost}/api/parties/${widget.party.id}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authenticationProvider.token}',
        'X-Requested-With': 'XMLHttpRequest'
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        _party = PartyModel.fromJson(data['party']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final ThemeData themeData = Theme.of(context);
    final AuthenticationProvider authenticationProvider = context.watch<AuthenticationProvider>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              navigatorState.restorablePushNamed(
                EditPartyView.routeName,
                arguments: _party.asJson
              );
            },
            icon: const Icon(Icons.edit)
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text(appLocalizations.viewPartyViewDeleteModalText),
                  title: Text(appLocalizations.viewPartyViewDeleteModalTitle),
                  actions: [
                    TextButton(
                      onPressed: () {
                        navigatorState.pop();
                      },
                      child: Text(appLocalizations.viewPartyViewDeleteModalNoActionText)
                    ),
                    TextButton(
                      onPressed: () async {
                        final http.Response response = await http.delete(
                          Uri.parse('${Constants.apiHost}/api/parties/${_party.id}'),
                          headers: {
                            'Accept': 'application/json',
                            'Authorization': 'Bearer ${authenticationProvider.token}',
                            'X-Requested-With': 'XMLHttpRequest'
                          }
                        );

                        if(response.statusCode == 200) {
                          navigatorState.pop();
                          navigatorState.pop();
                        }
                      },
                      child: Text(appLocalizations.viewPartyViewDeleteModalYesActionText)
                    ),
                  ],
                )
              );
            },
            icon: const Icon(Icons.delete)
          )
        ],
        title: Text(appLocalizations.viewPartyViewTitle)
      ),
      body: RefreshIndicator(
        onRefresh: _getParty,
        child: ListView(
          padding: const EdgeInsets.all(21.0),
          children: [
            Text(
              _party.name,
              style: themeData.textTheme.titleLarge
            ),
            const SizedBox(
              height: 21.0
            ),
            Text('Created at → ${DateFormat.yMMMMd().add_jms().format(_party.createdAt)}'),
            Text('Last updated at → ${DateFormat.yMMMMd().add_jms().format(_party.updatedAt)}')
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
    _getParty();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _party = widget.party;

    _getParty();
  }
}