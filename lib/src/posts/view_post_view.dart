import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../aspirants/view_aspirant_view.dart';
import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../constituencies/view_constituency_view.dart';
import '../models/post_model.dart';
import '../parties/view_party_view.dart';
import '../positions/view_position_view.dart';
import 'edit_post_view.dart';

class ViewPostView extends StatefulWidget {
  static const String routeName = '/posts/view';

  final PostModel post;

  const ViewPostView({
    super.key,
    required this.post
  });

  @override
  State<ViewPostView> createState() => _ViewPostViewState();
}

class _ViewPostViewState extends State<ViewPostView> with RouteAware {
  late PostModel _post;

  Future<void> _getPost() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiHost}/api/posts/${widget.post.id}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authenticationProvider.token}',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );

      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _post = PostModel.fromJson(data['post']);
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
        actions: _post.aspirant!.user!.id == authenticationProvider.user?.id ? [
          IconButton(
            onPressed: () {
              navigatorState.restorablePushNamed(
                EditPostView.routeName,
                arguments: _post.asJson
              );
            },
            icon: const Icon(Icons.edit_outlined)
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text(appLocalizations.deletePostTitle),
                  title: Text(appLocalizations.doYouWishToDeleteThisPostPrompt),
                  actions: [
                    TextButton(
                      onPressed: () {
                        navigatorState.pop();
                      },
                      child: Text(appLocalizations.noAction)
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          final http.Response response = await http.delete(
                            Uri.parse('${Constants.apiHost}/api/posts/${_post.id}'),
                            headers: {
                              'Accept': 'application/json',
                              'Authorization': 'Bearer ${authenticationProvider.token}',
                              'X-Requested-With': 'XMLHttpRequest'
                            }
                          );

                          if(response.statusCode == 200) {
                            navigatorState.pop();
                            navigatorState.pop();
                          }
                        } catch(error) {
                          //
                        }
                      },
                      child: Text(appLocalizations.yesAction)
                    ),
                  ]
                )
              );
            },
            icon: const Icon(Icons.delete_outlined)
          )
        ] : null,
        title: Text(appLocalizations.viewPostTitle)
      ),
      body: RefreshIndicator(
        onRefresh: _getPost,
        child: ListView(
          padding: const EdgeInsets.all(21.0),
          children: [
            Text(
              _post.title,
              style: themeData.textTheme.titleLarge
            ),
            Text(_post.body),
            const SizedBox(
              height: 21.0
            ),
            if(_post.aspirant!.user!.id == authenticationProvider.user?.id) Text('${appLocalizations.createdByPrompt} → You'),
            if(_post.aspirant!.user!.id != authenticationProvider.user?.id) ...[
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('${appLocalizations.createdByPrompt} → '),
                  TextButton(
                    onPressed: () {
                      navigatorState.restorablePushNamed(
                        ViewAspirantView.routeName,
                        arguments: _post.aspirant!.asJson
                      );
                    },
                    child: Text(_post.aspirant!.user!.name)
                  )
                ],
              ),
              switch(authenticationProvider.user?.role?.name) {
                'Administrator' => Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        navigatorState.restorablePushNamed(
                          ViewPositionView.routeName,
                          arguments: _post.aspirant!.position!.asJson
                        );
                      },
                      child: Text(_post.aspirant!.position!.name)
                    ),
                    const Text(' | '),
                    TextButton(
                      onPressed: () {
                        navigatorState.restorablePushNamed(
                          ViewPartyView.routeName,
                          arguments: _post.aspirant!.party!.asJson
                        );
                      },
                      child: Text(_post.aspirant!.party!.name)
                    ),
                    const Text(' | '),
                    TextButton(
                      onPressed: () {
                        navigatorState.restorablePushNamed(
                          ViewConstituencyView.routeName,
                          arguments: _post.aspirant!.constituency!.asJson
                        );
                      },
                      child: Text('${_post.aspirant!.constituency!.name} (${_post.aspirant!.constituency!.region!.name})')
                    )
                  ]
                ),
                _ => Text('${_post.aspirant!.position!.name} | ${_post.aspirant!.party!.name} | ${_post.aspirant!.constituency!.name} (${_post.aspirant!.constituency!.region!.name})')
              }
            ],
            Text('${appLocalizations.createdAtPrompt} → ${DateFormat.yMMMMd().add_jms().format(_post.createdAt)}'),
            Text('${appLocalizations.lastUpdatedAtPrompt} → ${DateFormat.yMMMMd().add_jms().format(_post.updatedAt)}')
          ]
        )
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
    _getPost();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _post = widget.post;

    _getPost();
  }
}
