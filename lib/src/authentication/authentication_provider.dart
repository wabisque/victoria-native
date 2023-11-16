import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/user_model.dart';
import '../provider.dart';
import 'authentication_service.dart';

class AuthenticationProvider extends Provider {
  final AuthenticationService _authenticationService;
  UserModel? _user;

  bool get isLoggedIn => token.isNotEmpty && _user != null;

  String get token => _authenticationService.token;

  UserModel? get user => _user;
  
  AuthenticationProvider(this._authenticationService);

  Future<void> init() async {
    await Future.wait([
      refreshUser()
    ]);
  }

  Future<Map<String, dynamic>?> login({
    required String id,
    required String password
  }) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('${Constants.apiHost}/api/authentication/login'),
        body: jsonEncode({
          'id': id,
          'password': password
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      final Map<String, dynamic> data = jsonDecode(response.body);

      if(response.statusCode == 200) {
        await _authenticationService.setToken(data['token']);

        _user = UserModel.fromJson(data['user']);

        notifyListeners();

        return null;
      }

      return data;
    } catch (error) {
      return {
        'message': error.toString()
      };
    }
  }

  Future<Map<String, dynamic>?> logout() async {
    try {
      final http.Response response = await http.post(
        Uri.parse('${Constants.apiHost}/api/authentication/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      final Map<String, dynamic> data = jsonDecode(response.body);

      if(response.statusCode == 200) {
        await _authenticationService.setToken('');

        _user = null;

        notifyListeners();

        return null;
      }

      return data;
    } catch (error) {
      return {
        'message': error.toString()
      };
    }
  }

  Future<void> refreshUser() async {
    if(token.isEmpty) return;

    try {
      final http.Response response = await http.get(
        Uri.parse('${Constants.apiHost}/api/authentication/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      
      if(response.statusCode == 200) {
        _user = UserModel.fromJson(jsonDecode(response.body)['user']);
      } else {
        _authenticationService.setToken('');
      }

      notifyListeners();
    } catch (error) {
      //
    }
  }

  Future<Map<String, dynamic>?> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String passwordConfirmation
  }) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('${Constants.apiHost}/api/authentication/register'),
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
          'password_confirmation': passwordConfirmation
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      final Map<String, dynamic> data = jsonDecode(response.body);

      if(response.statusCode == 200) {

        await _authenticationService.setToken(data['token']);

        _user = UserModel.fromJson(data['user']);

        notifyListeners();

        return null;
      }

      return data;
    } catch (error) {
      return {
        'message': error.toString()
      };
    }
  }

  Future<Map<String, dynamic>?> updateDetails({
    required String name,
    required String email,
    required String phoneNumber
  }) async {
    try {
      final http.Response response = await http.put(
        Uri.parse('${Constants.apiHost}/api/authentication/update-details'),
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone_number': phoneNumber
        }),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      final Map<String, dynamic> data = jsonDecode(response.body);

      if(response.statusCode == 200) {
        _user = UserModel.fromJson(data['user']);

        notifyListeners();

        return null;
      }

      return data;
    } catch (error) {
      return {
        'message': error.toString()
      };
    }
  }

  Future<Map<String, dynamic>?> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation
  }) async {
    try {
      final http.Response response = await http.put(
        Uri.parse('${Constants.apiHost}/api/authentication/update-details'),
        body: jsonEncode({
          'current_password': currentPassword,
          'password': password,
          'password_confirmation': passwordConfirmation
        }),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      );
      final Map<String, dynamic> data = jsonDecode(response.body);

      if(response.statusCode == 200) {
        _user = UserModel.fromJson(data['user']);

        notifyListeners();

        return null;
      }

      return data;
    } catch (error) {
      return {
        'message': error.toString()
      };
    }
  }
}
