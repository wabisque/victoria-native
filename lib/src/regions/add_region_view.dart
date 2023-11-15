import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';

class AddRegionView extends StatefulWidget {
  static const String routeName = '/regions/add';

  const AddRegionView({
    super.key
  });

  @override
  State<AddRegionView> createState() => _AddRegionViewState();
}

class _AddRegionViewState extends State<AddRegionView> with RouteAware {
  Map<String, List>? _formErrors;
  late GlobalKey _formKey;
  late TextEditingController _nameFieldController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.addRegionViewTitle)
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
                    TextFormField(
                      controller: _nameFieldController,
                      decoration: InputDecoration(
                        errorText: _formErrors?['name']?.first,
                        labelText: appLocalizations.addRegionViewNameFieldLabel
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
                            final http.Response response = await http.post(
                              Uri.parse('${Constants.apiHost}/api/regions'),
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
                          child: Text(appLocalizations.addRegionViewSubmitActionText)
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
  void dispose() {
    _nameFieldController.dispose();
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _nameFieldController = TextEditingController();
  }
}
