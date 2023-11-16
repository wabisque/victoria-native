import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';

class UserProfileView extends StatefulWidget {
  static const String routeName = '/settings/user-profile';

  const UserProfileView({
    super.key
  });

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> with RouteAware {
  Map<String, List>? _formErrors;
  late GlobalKey _formKey;
  late TextEditingController _emailFieldController;
  late TextEditingController _nameFieldController;
  late TextEditingController _phoneFieldController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.userProfileTitle)
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
                        labelText: appLocalizations.nameLabel
                      )
                    ),
                    const SizedBox(
                      height: 7.0
                    ),
                    TextFormField(
                      controller: _emailFieldController,
                      decoration: InputDecoration(
                        errorText: _formErrors?['email']?.first,
                        labelText: appLocalizations.emailLabel
                      )
                    ),
                    const SizedBox(
                      height: 7.0
                    ),
                    TextFormField(
                      controller: _phoneFieldController,
                      decoration: InputDecoration(
                        errorText: _formErrors?['phone_number']?.first,
                        labelText: appLocalizations.phoneLabel
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
                            final Map<String, dynamic>? error = await authenticationProvider.updateDetails(
                              email: _emailFieldController.text,
                              name: _nameFieldController.text,
                              phoneNumber: _phoneFieldController.text
                            );

                            if(error == null) navigatorState.pop();

                            setState(() {
                              _formErrors = (error?['errors'] as Map<String, dynamic>?)?.cast<String, List>();
                            });
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
  void dispose() {
    _emailFieldController.dispose();
    _nameFieldController.dispose();
    _phoneFieldController.dispose();
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    _formKey = GlobalKey();
    _emailFieldController = TextEditingController(
      text: authenticationProvider.user!.email
    );
    _nameFieldController = TextEditingController(
      text: authenticationProvider.user!.name
    );
    _phoneFieldController = TextEditingController(
      text: authenticationProvider.user!.phoneNumber
    );
  }
}
