import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/region_model.dart';
import 'edit_region_view.dart';

class ViewRegionView extends StatefulWidget {
  static const String routeName = '/regions/view';

  final RegionModel region;

  const ViewRegionView({
    super.key,
    required this.region
  });

  @override
  State<ViewRegionView> createState() => _ViewRegionViewState();
}

class _ViewRegionViewState extends State<ViewRegionView> with RouteAware {
  late RegionModel _region;

  Future<void> _getRegion() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    final http.Response response = await http.get(
      Uri.parse('${Constants.apiHost}/api/regions/${widget.region.id}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authenticationProvider.token}',
        'X-Requested-With': 'XMLHttpRequest'
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        _region = RegionModel.fromJson(data['region']);
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
                EditRegionView.routeName,
                arguments: _region.asJson
              );
            },
            icon: const Icon(Icons.edit)
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text(appLocalizations.viewRegionViewDeleteModalText),
                  title: Text(appLocalizations.viewRegionViewDeleteModalTitle),
                  actions: [
                    TextButton(
                      onPressed: () {
                        navigatorState.pop();
                      },
                      child: Text(appLocalizations.viewRegionViewDeleteModalNoActionText)
                    ),
                    TextButton(
                      onPressed: () async {
                        final http.Response response = await http.delete(
                          Uri.parse('${Constants.apiHost}/api/regions/${_region.id}'),
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
                      child: Text(appLocalizations.viewRegionViewDeleteModalYesActionText)
                    ),
                  ],
                )
              );
            },
            icon: const Icon(Icons.delete)
          )
        ],
        title: Text(appLocalizations.viewRegionViewTitle)
      ),
      body: RefreshIndicator(
        onRefresh: _getRegion,
        child: ListView(
          padding: const EdgeInsets.all(21.0),
          children: [
            Text(
              _region.name,
              style: themeData.textTheme.titleLarge
            ),
            const SizedBox(
              height: 21.0
            ),
            Text('Created at → ${DateFormat.yMMMMd().add_jms().format(_region.createdAt)}'),
            Text('Last updated at → ${DateFormat.yMMMMd().add_jms().format(_region.updatedAt)}')
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
    _getRegion();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _region = widget.region;

    _getRegion();
  }
}
