import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/constituency_model.dart';
import '../models/region_model.dart';

class EditConstituencyView extends StatefulWidget {
  static const String routeName = '/constituencies/edit';

  final ConstituencyModel constituency;

  const EditConstituencyView({
    super.key,
    required this.constituency
  });

  @override
  State<EditConstituencyView> createState() => _EditConstituencyViewState();
}

class _EditConstituencyViewState extends State<EditConstituencyView> with RouteAware {
  Map<String, List>? _formErrors;
  late GlobalKey _formKey;
  late TextEditingController _nameFieldController;
  int? _regionId;
  late List<RegionModel> _regions;

  Future<void> _getRegions() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiHost}/api/regions'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authenticationProvider.token}',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      
      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _regions = (data['regions']! as List).map((region) => RegionModel.fromJson(region)).toList();
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
        title: Text(appLocalizations.editConstituencyTitle)
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(21.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.constituency.name,
                      style: themeData.textTheme.titleLarge
                    ),
                    Text(
                      widget.constituency.region!.name,
                      style: themeData.textTheme.labelLarge
                    ),
                    const SizedBox(
                      height: 21.0
                    ),
                    TextFormField(
                      controller: _nameFieldController,
                      decoration: InputDecoration(
                        errorText: _formErrors?['name']?.first,
                        label: Text(appLocalizations.nameLabel)
                      )
                    ),
                    const SizedBox(
                      height: 7.0
                    ),
                    DropdownButtonFormField<RegionModel>(
                      decoration: InputDecoration(
                        errorText: _formErrors?['region']?.first,
                        labelText: appLocalizations.regionLabel,
                      ),
                      items: _regions.map((region) => DropdownMenuItem<RegionModel>(
                        value: region,
                        child: Text(region.name)
                      )).toList(),
                      onChanged: (RegionModel? region) {
                        setState(() {
                          _regionId = region?.id;
                        });
                      },
                      value: _regions.where((region) => region.id == _regionId).firstOrNull,
                    ),
                    const SizedBox(
                      height: 21.0
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                          onPressed: () async {
                            try {
                              final http.Response response = await http.put(
                                Uri.parse('${Constants.apiHost}/api/constituencies/${widget.constituency.id}'),
                                body: jsonEncode({
                                  'name': _nameFieldController.text,
                                  'region': _regionId
                                }),
                                headers: {
                                  'Accept': 'application/json',
                                  'Authorization': 'Bearer ${authenticationProvider.token}',
                                  'Content-Type': 'application/json',
                                  'X-Requested-With': 'XMLHttpRequest'
                                }
                              );
                              final Map<String, dynamic> data = jsonDecode(response.body);

                              if(response.statusCode == 200) {
                                navigatorState.pop();
                              } else {
                                setState(() {
                                  _formErrors = (data['errors'] as Map<String, dynamic>?)?.cast<String, List>();
                                });
                              }
                            } catch(error) {
                              //
                            }
                          },
                          child: Text(appLocalizations.saveAction)
                        )
                      ]
                    )
                  ]
                )
              )
            )
          )
        ]
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
    _getRegions();
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _nameFieldController = TextEditingController(
      text: widget.constituency.name
    );
    _regions = [];
    _regionId = widget.constituency.region!.id;

    _getRegions();
  }
}
