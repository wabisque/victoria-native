import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/region_model.dart';

class EditRegionView extends StatefulWidget {
  static const String routeName = '/regions/edit';

  final RegionModel region;

  const EditRegionView({
    super.key,
    required this.region
  });

  @override
  State<EditRegionView> createState() => _EditRegionViewState();
}

class _EditRegionViewState extends State<EditRegionView> with RouteAware {
  Map<String, List>? _formErrors;
  late GlobalKey _formKey;
  late TextEditingController _nameFieldController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final ThemeData themeData = Theme.of(context);
    final AuthenticationProvider authenticationProvider = context.watch<AuthenticationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.editRegionViewTitle)
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
                      widget.region.name,
                      style: themeData.textTheme.titleLarge
                    ),
                    const SizedBox(
                      height: 21.0
                    ),
                    TextFormField(
                      controller: _nameFieldController,
                      decoration: InputDecoration(
                        errorText: _formErrors?['name']?.first,
                        label: Text(appLocalizations.editRegionViewNameFieldLabel)
                      )
                    ),
                    const SizedBox(
                      height: 21.0
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                          onPressed: () async {
                            final http.Response response = await http.put(
                              Uri.parse('${Constants.apiHost}/api/regions/${widget.region.id}'),
                              body: jsonEncode({
                                'name': _nameFieldController.text
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
                                _formErrors = data['errors']?.cast<String, List>();
                              });
                            }
                          },
                          child: Text(appLocalizations.editRegionViewSubmitActionText)
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
    //
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
      text: widget.region.name
    );
  }
}
