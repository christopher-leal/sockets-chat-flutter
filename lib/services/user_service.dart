import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/user.dart';
import 'package:realtime_chat/services/auth_service.dart';

class UserService with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future getUsers() async {
    final resp = await http.post('${Enviroment.apiUrl}/users',
        body: {'from': '0'}, headers: {'token': await AuthService.getToken()});
    if (resp.statusCode == 200) {
      // _users = usersFromJson(resp.body).data;
      final data = jsonDecode(resp.body);
      Iterable users = data['data'] as Iterable;
      _users = users.map((user) => User.fromJson(user)).toList();
      return notifyListeners();
    }
    _users = [];
    notifyListeners();
  }
}
