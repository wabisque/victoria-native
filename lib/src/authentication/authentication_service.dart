import '../constants.dart';

class AuthenticationService {
  String get token => Constants.preferences.getString('authentication:token')!;

  Future<void> setToken(String token) async => await Constants.preferences.setString(
    'authentication:token',
    token
  );
}
