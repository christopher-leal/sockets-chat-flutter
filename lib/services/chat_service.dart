import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/message.dart';
import 'package:realtime_chat/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat/services/auth_service.dart';

class ChatService with ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  set messages(List<Message> messages) {
    _messages = messages;
    notifyListeners();
  }

  User _userTo;

  User get userTo => _userTo;

  set userTo(User userTo) {
    _userTo = userTo;
    notifyListeners();
  }

  Future<void> getMessages(String toId) async {
    final data = {'messageTo': toId};
    // final resp = await http.post('${Enviroment.apiUrl}/messages',
    //     body: {'messageTo': toId},
    //     headers: {'token': await AuthService.getToken()});
    final resp = await http.post('${Enviroment.apiUrl}/messages',
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'token': await AuthService.getToken()
        });

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      Iterable messages = data['data'] as Iterable;
      _messages = messages.map((message) => Message.fromJson(message)).toList();
      notifyListeners();
      return;
    }
    notifyListeners();
    return;
  }
}
