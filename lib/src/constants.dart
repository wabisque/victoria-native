import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Constants {
  static const String apiHost = 'http://localhost:8000';
  static late final SharedPreferences preferences;
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
}
