import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/post_model.dart';

class EditPostView extends StatefulWidget {
  static const String routeName = '/posts/edit';

  final PostModel post;

  const EditPostView({
    super.key,
    required this.post
  });

  @override
  State<EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> with RouteAware {
  Map<String, List>? _formErrors;
  late GlobalKey _formKey;
  late TextEditingController _bodyFieldController;
  late TextEditingController _titleFieldController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final NavigatorState navigatorState = Navigator.of(context);
    final AuthenticationProvider authenticationProvider = context.watch<AuthenticationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.editPostTitle)
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
                      controller: _titleFieldController,
                      decoration: InputDecoration(
                        errorText: _formErrors?['title']?.first,
                        labelText: appLocalizations.titleLabel
                      )
                    ),
                    const SizedBox(
                      height: 7.0
                    ),
                    TextFormField(
                      controller: _bodyFieldController,
                      decoration: InputDecoration(
                        errorText: _formErrors?['body']?.first,
                        labelText: appLocalizations.bodyLabel
                      ),
                      maxLines: 4,
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
                                Uri.parse('${Constants.apiHost}/api/posts/${widget.post.id}'),
                                body: jsonEncode({
                                  'body': _bodyFieldController.text,
                                  'title': _titleFieldController.text
                                }),
                                headers: {
                                  'Accept': 'application/json',
                                  'Authorization': 'Bearer ${authenticationProvider.token}',
                                  'Content-Type': 'application/json',
                                  'X-Requested-With': 'XMLHttpRequest'
                                }
                              );
                              final Map<String, dynamic> data = jsonDecode(response.body);

                              print(response.body);

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
    //
  }

  @override
  void dispose() {
    _bodyFieldController.dispose();
    _titleFieldController.dispose();
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _bodyFieldController = TextEditingController(
      text: widget.post.body
    );
    _titleFieldController = TextEditingController(
      text: widget.post.title
    );
  }
}
