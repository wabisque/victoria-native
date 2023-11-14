import '../preferences.dart';

class AuthenticationService {
  String get token => Preferences.instance.getString('authentication:token')!;

  Future<void> setToken(String token) async => await Preferences.instance.setString(
    'authentication:token',
    token
  );
}
