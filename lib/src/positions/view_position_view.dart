import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/position_model.dart';
import 'edit_position_view.dart';

class ViewPositionView extends StatefulWidget {
  static const String routeName = '/positions/view';

  final PositionModel position;

  const ViewPositionView({
    super.key,
    required this.position
  });

  @override
  State<ViewPositionView> createState() => _ViewPositionViewState();
}

class _ViewPositionViewState extends State<ViewPositionView> with RouteAware {
  late PositionModel _position;

  Future<void> _getPosition() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    final http.Response response = await http.get(
      Uri.parse('${Constants.apiHost}/api/positions/${widget.position.id}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authenticationProvider.token}',
        'X-Requested-With': 'XMLHttpRequest'
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        _position = PositionModel.fromJson(data['position']);
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
                EditPositionView.routeName,
                arguments: _position.asJson
              );
            },
            icon: const Icon(Icons.edit)
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text(appLocalizations.viewPositionViewDeleteModalText),
                  title: Text(appLocalizations.viewPositionViewDeleteModalTitle),
                  actions: [
                    TextButton(
                      onPressed: () {
                        navigatorState.pop();
                      },
                      child: Text(appLocalizations.viewPositionViewDeleteModalNoActionText)
                    ),
                    TextButton(
                      onPressed: () async {
                        final http.Response response = await http.delete(
                          Uri.parse('${Constants.apiHost}/api/positions/${_position.id}'),
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
                      child: Text(appLocalizations.viewPositionViewDeleteModalYesActionText)
                    ),
                  ],
                )
              );
            },
            icon: const Icon(Icons.delete)
          )
        ],
        title: Text(appLocalizations.viewPositionViewTitle)
      ),
      body: RefreshIndicator(
        onRefresh: _getPosition,
        child: ListView(
          padding: const EdgeInsets.all(21.0),
          children: [
            Text(
              _position.name,
              style: themeData.textTheme.titleLarge
            ),
            const SizedBox(
              height: 21.0
            ),
            Text('Created at → ${DateFormat.yMMMMd().add_jms().format(_position.createdAt)}'),
            Text('Last updated at → ${DateFormat.yMMMMd().add_jms().format(_position.updatedAt)}')
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
    _getPosition();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _position = widget.position;

    _getPosition();
  }
}
