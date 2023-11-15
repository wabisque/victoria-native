import 'dart:convert';

abstract class Model {
  const Model();

  Map<String, dynamic> get asJson => jsonDecode(jsonEncode(this));

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap();
}
