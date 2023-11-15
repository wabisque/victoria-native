import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/aspirant_model.dart';

class AspirantsTabView extends StatefulWidget {
  const AspirantsTabView({
    super.key
  });

  @override
  State<AspirantsTabView> createState() => _AspirantsTabViewState();
}

class _AspirantsTabViewState extends State<AspirantsTabView> {
  late List<AspirantModel> _aspirants;

  Future<void> _getAspirants() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();
    final http.Response response = await http.get(
      Uri.parse('${Constants.apiHost}/api/posts'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authenticationProvider.token}',
        'X-Requested-With': 'XMLHttpRequest'
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        _aspirants = (data['aspirants']! as List).map((aspirant) => AspirantModel.fromJson(aspirant)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    
    return RefreshIndicator(
      onRefresh: _getAspirants,
      child: _aspirants.isNotEmpty ? ListView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: 21.0
        ),
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text(_aspirants[index].user!.name),
          subtitle: Text('${_aspirants[index].position!.name} | ${_aspirants[index].party!.name} | ${_aspirants[index].constituency!.name} (${_aspirants[index].constituency!.region!.name})'),
        ),
        itemCount: _aspirants.length,
      ) : Center(
        child: Text(appLocalizations.dashboardAspirantsTabViewEmptyText)
      )
    );
  }

  @override
  void initState() {
    super.initState();

    _aspirants = [];
  }
}
