import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/constituency_model.dart';
import 'edit_constituency_view.dart';

class ViewConstituencyView extends StatefulWidget {
  static const String routeName = '/constituencies/view';

  final ConstituencyModel constituency;

  const ViewConstituencyView({
    super.key,
    required this.constituency
  });

  @override
  State<ViewConstituencyView> createState() => _ViewConstituencyViewState();
}

class _ViewConstituencyViewState extends State<ViewConstituencyView> with RouteAware {
  late ConstituencyModel _constituency;

  Future<void> _getConstituency() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    final http.Response response = await http.get(
      Uri.parse('${Constants.apiHost}/api/constituencies/${widget.constituency.id}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authenticationProvider.token}',
        'X-Requested-With': 'XMLHttpRequest'
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        _constituency = ConstituencyModel.fromJson(data['constituency']);
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
                EditConstituencyView.routeName,
                arguments: _constituency.asJson
              );
            },
            icon: const Icon(Icons.edit)
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text(appLocalizations.viewConstituencyViewDeleteModalText),
                  title: Text(appLocalizations.viewConstituencyViewDeleteModalTitle),
                  actions: [
                    TextButton(
                      onPressed: () {
                        navigatorState.pop();
                      },
                      child: Text(appLocalizations.viewConstituencyViewDeleteModalNoActionText)
                    ),
                    TextButton(
                      onPressed: () async {
                        final http.Response response = await http.delete(
                          Uri.parse('${Constants.apiHost}/api/constituencies/${_constituency.id}'),
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
                      child: Text(appLocalizations.viewConstituencyViewDeleteModalYesActionText)
                    ),
                  ],
                )
              );
            },
            icon: const Icon(Icons.delete)
          )
        ],
        title: Text(appLocalizations.viewConstituencyViewTitle)
      ),
      body: RefreshIndicator(
        onRefresh: _getConstituency,
        child: ListView(
          padding: const EdgeInsets.all(21.0),
          children: [
            Text(
              _constituency.name,
              style: themeData.textTheme.titleLarge
            ),
            Text(
              _constituency.region!.name,
              style: themeData.textTheme.labelLarge
            ),
            const SizedBox(
              height: 21.0
            ),
            Text('Created at → ${DateFormat.yMMMMd().add_jms().format(_constituency.createdAt)}'),
            Text('Last updated at → ${DateFormat.yMMMMd().add_jms().format(_constituency.updatedAt)}')
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
    _getConstituency();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _constituency = widget.constituency;

    _getConstituency();
  }
}
