import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';
import '../constants.dart';
import '../models/constituency_model.dart';
import '../models/party_model.dart';
import '../models/position_model.dart';
import '../widgets/image_picker_widget.dart';

class BecomeAnAspirantView extends StatefulWidget {
  static const String routeName = '/settings/become-an-aspirant';

  const BecomeAnAspirantView({
    super.key
  });

  @override
  State<BecomeAnAspirantView> createState() => _BecomeAnAspirantViewState();
}

class _BecomeAnAspirantViewState extends State<BecomeAnAspirantView> with RouteAware {
  File? _flyer;
  Map<String, List>? _formErrors;
  late GlobalKey _formKey;
  late TextEditingController _addressFieldController;
  late List<ConstituencyModel> _constituencies;
  int? _constituencyId;
  late List<PartyModel> _parties;
  int? _partyId;
  late List<PositionModel> _positions;
  int? _positionId;

  Future<void> _getConstituencies() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiHost}/api/constituencies'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authenticationProvider.token}',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      
      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _constituencies = (data['constituencies']! as List).map((constituency) => ConstituencyModel.fromJson(constituency)).toList();
        });
      }
    } catch(error) {
      //
    }
  }

  Future<void> _getParties() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiHost}/api/parties'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authenticationProvider.token}',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      
      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _parties = (data['parties']! as List).map((party) => PartyModel.fromJson(party)).toList();
        });
      }
    } catch(error) {
      //
    }
  }

  Future<void> _getPositions() async {
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiHost}/api/positions'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authenticationProvider.token}',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      
      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _positions = (data['positions']! as List).map((positions) => PositionModel.fromJson(positions)).toList();
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
    final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.becomeAnAspirantTitle)
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            _getConstituencies(),
            _getParties(),
            _getPositions()
          ]);
        },
        child: CustomScrollView(
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
                      DropdownButtonFormField<PositionModel>(
                        decoration: InputDecoration(
                          errorText: _formErrors?['position']?.first,
                          labelText: appLocalizations.positionLabel,
                        ),
                        items: _positions.map((position) => DropdownMenuItem<PositionModel>(
                          value: position,
                          child: Text(position.name)
                        )).toList(),
                        onChanged: (PositionModel? position) {
                          setState(() {
                            _positionId = position?.id;
                          });
                        },
                        value: _positions.where((position) => position.id == _positionId).firstOrNull
                      ),
                      const SizedBox(
                        height: 7.0
                      ),
                      DropdownButtonFormField<PartyModel>(
                        decoration: InputDecoration(
                          errorText: _formErrors?['party']?.first,
                          labelText: appLocalizations.partyLabel,
                        ),
                        items: _parties.map((party) => DropdownMenuItem<PartyModel>(
                          value: party,
                          child: Text(party.name)
                        )).toList(),
                        onChanged: (PartyModel? party) {
                          setState(() {
                            _partyId = party?.id;
                          });
                        },
                        value: _parties.where((party) => party.id == _partyId).firstOrNull
                      ),
                      const SizedBox(
                        height: 7.0
                      ),
                      DropdownButtonFormField<ConstituencyModel>(
                        decoration: InputDecoration(
                          errorText: _formErrors?['constituency']?.first,
                          labelText: appLocalizations.constituencyLabel,
                        ),
                        items: _constituencies.map((constituency) => DropdownMenuItem<ConstituencyModel>(
                          value: constituency,
                          child: Text('${constituency.name} (${constituency.region!.name})')
                        )).toList(),
                        onChanged: (ConstituencyModel? constituency) {
                          setState(() {
                            _constituencyId = constituency?.id;
                          });
                        },
                        value: _constituencies.where((constituency) => constituency.id == _constituencyId).firstOrNull
                      ),
                      const SizedBox(
                        height: 7.0
                      ),
                      TextFormField(
                        controller: _addressFieldController,
                        decoration: InputDecoration(
                          errorText: _formErrors?['address']?.first,
                          labelText: appLocalizations.addressLabel
                        )
                      ),
                      const SizedBox(
                        height: 7.0
                      ),
                      Text(
                        appLocalizations.flyerLabel,
                        style: themeData.textTheme.labelLarge?.copyWith(
                          color: _formErrors?['flyer']?.first != null ? themeData.colorScheme.error : themeData.colorScheme.onBackground
                        )
                      ),
                      const SizedBox(
                        height: 3.5
                      ),
                      ImagePickerWidget(
                        onChanged: (File? image) {
                          setState(() {
                            _flyer = image;
                          });
                        },
                      ),
                      if(_formErrors?['flyer']?.first != null) ...[
                        const SizedBox(
                          height: 3.5
                        ),
                        Text(
                          _formErrors?['flyer']!.first,
                          style: themeData.textTheme.bodySmall?.copyWith(
                            color: themeData.colorScheme.error
                          )
                        )
                      ],
                      const SizedBox(
                        height: 21.0
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Badge(
                            isLabelVisible: authenticationProvider.user?.hasAspirantCreationRequest ?? false,
                            child: FilledButton(
                              onPressed: () async {
                                if(authenticationProvider.user?.hasAspirantCreationRequest ?? false) return;

                                try {
                                  final http.MultipartRequest request = http.MultipartRequest(
                                    'POST',
                                    Uri.parse('${Constants.apiHost}/api/aspirants')
                                  );

                                  request.fields['address'] = _addressFieldController.text;
                                  request.fields['constituency'] = _constituencyId.toString();
                                  request.fields['party'] = _partyId.toString();
                                  request.fields['position'] = _positionId.toString();

                                  if(_flyer != null) {
                                    final List<String> mimeData = lookupMimeType(_flyer!.path)!.split('/');

                                    request.files.add(
                                      http.MultipartFile(
                                        'flyer',
                                        http.ByteStream(_flyer!.openRead()),
                                        _flyer!.lengthSync(),
                                        filename: _flyer!.path.split(RegExp(r'[\/\\]+')).last,
                                        contentType: MediaType(
                                          mimeData[0],
                                          mimeData[1]
                                        )
                                      )
                                    );
                                  }

                                  request.headers.addAll({
                                    'Accept': 'application/json',
                                    'Authorization': 'Bearer ${authenticationProvider.token}',
                                    'X-Requested-With': 'XMLHttpRequest'
                                  });

                                  final http.Response response = await http.Response.fromStream(await request.send());
                                  final Map<String, dynamic> data = jsonDecode(response.body);

                                  if(response.statusCode == 200) {
                                    authenticationProvider.refreshUser();
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
                              child: Text(appLocalizations.applyAction)
                            )
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
    _getConstituencies();
    _getParties();
    _getPositions();
  }

  @override
  void dispose() {
    _addressFieldController.dispose();
    Constants.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _addressFieldController = TextEditingController();

    _constituencies = [];
    _parties = [];
    _positions = [];

    _getConstituencies();
    _getParties();
    _getPositions();
  }
}
