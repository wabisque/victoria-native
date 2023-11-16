import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../widgets/password_field_widget.dart';

class PasswordView extends StatefulWidget {
  static const String routeName = '/settings/password';

  const PasswordView({
    super.key
  });

  @override
  State<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> with RouteAware {
  Map<String, List>? _formErrors;
  late GlobalKey _formKey;
  late TextEditingController _confirmPasswordFieldController;
  late TextEditingController _currentPasswordFieldController;
  late TextEditingController _passwordFieldController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.changePasswordTitle)
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
                    PasswordFieldWidget(
                      controller: _currentPasswordFieldController,
                      decoration: InputDecoration(
                        errorText: _formErrors?['current_password']?.first,
                        labelText: appLocalizations.currentPasswordLabel
                      )
                    ),
                    const SizedBox(
                      height: 7.0
                    ),
                    PasswordFieldWidget(
                      controller: _passwordFieldController,
                      decoration: InputDecoration(
                        errorText: _formErrors?['password']?.first,
                        labelText: appLocalizations.newPasswordLabel
                      )
                    ),
                    const SizedBox(
                      height: 7.0
                    ),
                    PasswordFieldWidget(
                      controller: _confirmPasswordFieldController,
                      decoration: InputDecoration(
                        labelText: appLocalizations.confirmNewPasswordLabel
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
                            final Map<String, dynamic>? error = await authenticationProvider.updatePassword(
                              currentPassword: _currentPasswordFieldController.text,
                              password: _passwordFieldController.text,
                              passwordConfirmation: _confirmPasswordFieldController.text
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
    _confirmPasswordFieldController.dispose();
    _currentPasswordFieldController.dispose();
    _passwordFieldController.dispose();
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _confirmPasswordFieldController = TextEditingController();
    _currentPasswordFieldController = TextEditingController();
    _passwordFieldController = TextEditingController();
  }
}
