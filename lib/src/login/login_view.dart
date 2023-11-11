import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/password_field_widget.dart';

class LoginView extends StatefulWidget {
  static const String routeName = '/login';

  const LoginView({
    super.key
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late GlobalKey _formKey;
  late TextEditingController _idFieldController;
  late TextEditingController _passwordFieldController;

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
                      appLocalizations.loginViewTitle,
                      style: themeData.textTheme.titleLarge
                    ),
                    Text(appLocalizations.loginViewText),
                    const SizedBox(
                      height: 21.0
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _idFieldController,
                            decoration: InputDecoration(
                              labelText: appLocalizations.loginViewIdFieldLabel
                            )
                          ),
                          const SizedBox(
                            height: 7.0
                          ),
                          PasswordFieldWidget(
                            controller: _passwordFieldController,
                            decoration: InputDecoration(
                              labelText: appLocalizations.loginViewPasswordFieldLabel
                            )
                          )
                        ]
                      )
                    ),
                    const SizedBox(
                      height: 14.0
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(appLocalizations.loginViewForgotPasswordActionText)
                        ),
                        FilledButton(
                          onPressed: () {
                            navigatorState.pushNamed('/settings');
                          },
                          child: Text(appLocalizations.loginViewSubmitActionText)
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
                          appLocalizations.loginViewDividerText,
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
                          navigatorState.pushReplacementNamed('/register');
                        },
                        child: Text(appLocalizations.loginViewRegisterActionText)
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
    _idFieldController.dispose();
    _passwordFieldController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey(debugLabel: 'login_view_form_key');
    _idFieldController = TextEditingController();
    _passwordFieldController = TextEditingController();
  }
}
