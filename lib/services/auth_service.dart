import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/login_response.dart';
import 'package:realtime_chat/models/user.dart';

class AuthService with ChangeNotifier {
  User _user;
  bool _authenticating = false;
  final _storage = new FlutterSecureStorage();

  User get user => _user;

  bool get authenticating => _authenticating;

  set authenticating(bool authenticating) {
    _authenticating = authenticating;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final data = {"email": email, "password": password};

    _authenticating = true;

    final resp = await http.post('${Enviroment.apiUrl}/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      _user = loginResponse.user;
      await _saveToken(loginResponse.token);
      _authenticating = false;
      return true;
    }
    _authenticating = false;
    return false;
  }

  setUser(String name, String email, String password) async {
    _authenticating = true;
    final user = {"name": name, "email": email, "password": password};
    final resp = await http.post('${Enviroment.apiUrl}/login/new',
        body: jsonEncode(user), headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      _user = loginResponse.user;
      await _saveToken(loginResponse.token);
      return true;
    }
    _authenticating = false;
    return false;
  }

  logout() async {
    await _deleteToken();
  }

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final resp = await http.get('${Enviroment.apiUrl}/login/refresh',
        headers: {'Content-Type': 'application/json', "token": token});
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      _user = loginResponse.user;

      await _saveToken(loginResponse.token);

      return true;
    }
    await logout();
    return false;
  }

  Future<void> _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future<void> _deleteToken() async {
    return await _storage.delete(key: 'token');
  }
}
