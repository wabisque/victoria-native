import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/password_field_widget.dart';

class RegisterView extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterView({
    super.key
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late GlobalKey _formKey;
  late TextEditingController _emailFieldController;
  late TextEditingController _passwordFieldController;
  late TextEditingController _passwordConfirmFieldController;
  late TextEditingController _phoneFieldController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final ThemeData themeData = Theme.of(context);

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
                      appLocalizations.registerViewTitle,
                      style: themeData.textTheme.titleLarge
                    ),
                    Text(appLocalizations.registerViewText),
                    const SizedBox(
                      height: 21.0
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _emailFieldController,
                            decoration: InputDecoration(
                              labelText: appLocalizations.registerViewEmailFieldLabel
                            )
                          ),
                          const SizedBox(
                            height: 7.0
                          ),
                          TextFormField(
                            controller: _phoneFieldController,
                            decoration: InputDecoration(
                              labelText: appLocalizations.registerViewPhoneFieldLabel
                            )
                          ),
                          const SizedBox(
                            height: 7.0
                          ),
                          PasswordFieldWidget(
                            controller: _passwordFieldController,
                            decoration: InputDecoration(
                              labelText: appLocalizations.registerViewPasswordFieldLabel
                            )
                          ),
                          const SizedBox(
                            height: 7.0
                          ),
                          PasswordFieldWidget(
                            controller: _passwordConfirmFieldController,
                            decoration: InputDecoration(
                              labelText: appLocalizations.registerViewPasswordConfirmFieldLabel
                            )
                          )
                        ]
                      )
                    ),
                    const SizedBox(
                      height: 14.0
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                          onPressed: () {
                            navigatorState.pushNamed('/settings');
                          },
                          child: Text(appLocalizations.registerViewSubmitActionText)
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
                          appLocalizations.registerViewDividerText,
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
                          navigatorState.pushReplacementNamed('/login');
                        },
                        child: Text(appLocalizations.registerViewLoginActionText)
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
    _passwordFieldController = TextEditingController();
    _passwordConfirmFieldController = TextEditingController();
    _phoneFieldController = TextEditingController();
  }
}
