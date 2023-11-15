import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../constituencies/view_constituency_view.dart';
import '../models/aspirant_model.dart';
import '../parties/view_party_view.dart';
import '../positions/view_position_view.dart';

class ViewAspirantView extends StatefulWidget {
  static const String routeName = '/aspirants/view';

  final AspirantModel aspirant;

  const ViewAspirantView({
    super.key,
    required this.aspirant
  });

  @override
  State<ViewAspirantView> createState() => _ViewAspirantViewState();
}

class _ViewAspirantViewState extends State<ViewAspirantView> with RouteAware {
  late AspirantModel _aspirant;

  Future<void> _getAspirant() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    final http.Response response = await http.get(
      Uri.parse('${Constants.apiHost}/api/aspirants/${widget.aspirant.id}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authenticationProvider.token}',
        'X-Requested-With': 'XMLHttpRequest'
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        _aspirant = AspirantModel.fromJson(data['aspirant']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final ThemeData themeData = Theme.of(context);
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.viewAspirantViewTitle),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text(appLocalizations.viewAspirantViewDeleteModalText),
                  title: Text(appLocalizations.viewAspirantViewDeleteModalTitle),
                  actions: [
                    TextButton(
                      onPressed: () {
                        navigatorState.pop();
                      },
                      child: Text(appLocalizations.viewAspirantViewDeleteModalNoActionText)
                    ),
                    TextButton(
                      onPressed: () async {
                        final http.Response response = await http.delete(
                          Uri.parse('${Constants.apiHost}/api/aspirants/${_aspirant.id}'),
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
                      child: Text(appLocalizations.viewAspirantViewDeleteModalYesActionText)
                    ),
                  ],
                )
              );
            },
            icon: const Icon(Icons.delete)
          )
        ]
      ),
      body: RefreshIndicator(
        onRefresh: _getAspirant,
        child: ListView(
          padding: const EdgeInsets.all(21.0),
          children: [
            Text(
              _aspirant.user!.name,
              style: themeData.textTheme.titleLarge
            ),
            Text(
              _aspirant.user!.email,
              style: themeData.textTheme.labelLarge
            ),
            Text(
              _aspirant.user!.phoneNumber,
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
                          arguments: _aspirant.position!.asJson
                        );
                      },
                      child: Text(_aspirant.position!.name)
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
                          arguments: _aspirant.party!.asJson
                        );
                      },
                      child: Text(_aspirant.party!.name)
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
                          arguments: _aspirant.constituency!.asJson
                        );
                      },
                      child: Text('${_aspirant.constituency!.name} (${_aspirant.constituency!.region!.name})')
                    )
                  ]
                )
              ]
            ),
            const SizedBox(
              height: 21.0
            ),
            Text('Created at → ${DateFormat.yMMMMd().add_jms().format(_aspirant.createdAt)}'),
            Text('Last updated at → ${DateFormat.yMMMMd().add_jms().format(_aspirant.updatedAt)}')
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
    _getAspirant();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _aspirant = widget.aspirant;

    _getAspirant();
  }
}
