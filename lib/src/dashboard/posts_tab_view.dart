import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../localization/localization_provider.dart';
import '../models/post_model.dart';
import '../posts/add_post_view.dart';
import '../posts/view_post_view.dart';

class PostsTabView extends StatefulWidget {
  const PostsTabView({
    super.key
  });

  @override
  State<PostsTabView> createState() => _PostsTabViewState();
}

class _PostsTabViewState extends State<PostsTabView> with RouteAware {
  late List<PostModel> _posts;

  Future<void> _getPosts() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiHost}/api/posts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authenticationProvider.token}',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );

      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _posts = (data['posts']! as List).map((post) => PostModel.fromJson(post)).toList();
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
    final AuthenticationProvider authenticationProvider = context.watch<AuthenticationProvider>();
    final LocalizationProvider localizationProvider = context.watch<LocalizationProvider>();

    return RefreshIndicator(
      onRefresh: _getPosts,
      child: Scaffold(
        body: _posts.isNotEmpty ? ListView.builder(
          padding: const EdgeInsets.all(21.0),
          itemBuilder: (BuildContext context, int index) => Badge(
            isLabelVisible: _posts[index].aspirant!.user!.id == authenticationProvider.user?.id,
            child: ListTile(
              onTap: () {
                navigatorState.restorablePushNamed(
                  ViewPostView.routeName,
                  arguments: _posts[index].asJson
                );
              },
              title: Text(_posts[index].title),
              subtitle: Text('${_posts[index].body}\n[ ${_posts[index].aspirant!.user!.name}, ${timeago.format(
                _posts[index].createdAt,
                locale: localizationProvider.locale.languageCode
              )} ]'),
            )
          ),
          itemCount: _posts.length,
        ) : Stack(
          children: [
            Center(
              child: Text(appLocalizations.noPostsToShowPrompt)
            ),
            ListView()
          ]
        ),
        floatingActionButton: authenticationProvider.user?.role?.name == 'Aspirant' ? FloatingActionButton(
          onPressed: () {
            navigatorState.restorablePushNamed(AddPostView.routeName);
          },
          child: const Icon(Icons.add_outlined)
        ) : null
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
    _getPosts();
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _posts = [];
    
    _getPosts();
  }
}
