import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../dashboard/dashboard_view.dart';
import '../widgets/password_field_widget.dart';
import 'authentication_provider.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterView({
    super.key
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  Map<String, List>? _formErrors;
  late GlobalKey _formKey;
  late TextEditingController _emailFieldController;
  late TextEditingController _nameFieldController;
  late TextEditingController _passwordFieldController;
  late TextEditingController _passwordConfirmFieldController;
  late TextEditingController _phoneFieldController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final ThemeData themeData = Theme.of(context);
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(21.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appLocalizations.helloPrompt,
                      style: themeData.textTheme.titleLarge
                    ),
                    Text(appLocalizations.registerToBeginYourJourneyPrompt),
                    const SizedBox(
                      height: 21.0
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            height: 7.0
                          ),
                          PasswordFieldWidget(
                            controller: _passwordFieldController,
                            decoration: InputDecoration(
                              errorText: _formErrors?['password']?.first,
                              labelText: appLocalizations.passwordLabel
                            )
                          ),
                          const SizedBox(
                            height: 7.0
                          ),
                          PasswordFieldWidget(
                            controller: _passwordConfirmFieldController,
                            decoration: InputDecoration(
                              labelText: appLocalizations.confirmPasswordLabel
                            )
                          )
                        ]
                      )
                    ),
                    const SizedBox(
                      height: 14.0
                    ),
                    Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: () async {
                            final Map<String, dynamic>? error = await authenticationProvider.register(
                              email: _emailFieldController.text,
                              name: _nameFieldController.text,
                              password: _passwordFieldController.text,
                              passwordConfirmation: _passwordConfirmFieldController.text,
                              phoneNumber: _phoneFieldController.text
                            );
                            
                            if(error == null) navigatorState.restorablePushReplacementNamed(DashboardView.routeName);

                            setState(() {
                              _formErrors = (error?['errors'] as Map<String, dynamic>?)?.cast<String, List>();
                            });
                          },
                          child: Text(appLocalizations.registerAction)
                        )
                      ]
                    ),
                    const SizedBox(
                      height: 21.0
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            endIndent: 3.5
                          )
                        ),
                        Text(
                          appLocalizations.orPrompt,
                          style: TextStyle(
                            color: themeData.colorScheme.outline,
                            fontWeight: FontWeight.w300
                          )
                        ),
                        const Expanded(
                          child: Divider(
                            indent: 3.5
                          )
                        ),
                      ]
                    ),
                    const SizedBox(
                      height: 21.0
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          navigatorState.restorablePushReplacementNamed(LoginView.routeName);
                        },
                        child: Text(appLocalizations.alreadyHaveAnAccountAction)
                      )
                    )
                  ]
                )
              )
            )
          ],
        )
      )
    );
  }

  @override
  void dispose() {
    _emailFieldController.dispose();
    _nameFieldController.dispose();
    _passwordFieldController.dispose();
    _passwordConfirmFieldController.dispose();
    _phoneFieldController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey(debugLabel: 'login_view_form_key');
    _emailFieldController = TextEditingController();
    _nameFieldController = TextEditingController();
    _passwordFieldController = TextEditingController();
    _passwordConfirmFieldController = TextEditingController();
    _phoneFieldController = TextEditingController();
  }
}
