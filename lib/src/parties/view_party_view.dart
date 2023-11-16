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

    try {
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
    } catch(error) {
      //
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
            icon: const Icon(Icons.edit_outlined)
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text(appLocalizations.deletePartyTitle),
                  title: Text(appLocalizations.doYouWishToDeleteThisPartyPrompt),
                  actions: [
                    TextButton(
                      onPressed: () {
                        navigatorState.pop();
                      },
                      child: Text(appLocalizations.noAction)
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
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
                        } catch(error) {
                          //
                        }
                      },
                      child: Text(appLocalizations.yesAction)
                    ),
                  ],
                )
              );
            },
            icon: const Icon(Icons.delete_outline)
          )
        ],
        title: Text(appLocalizations.viewPartyTitle)
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
            Text('${appLocalizations.createdAtPrompt} → ${DateFormat.yMMMMd().add_jms().format(_party.createdAt)}'),
            Text('${appLocalizations.lastUpdatedAtPrompt} → ${DateFormat.yMMMMd().add_jms().format(_party.updatedAt)}')
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
