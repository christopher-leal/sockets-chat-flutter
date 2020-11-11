import 'package:flutter/cupertino.dart';
import 'package:realtime_chat/pages/chat_page.dart';
import 'package:realtime_chat/pages/login_page.dart';
import 'package:realtime_chat/pages/register_page.dart';
import 'package:realtime_chat/pages/users_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  "login": (context) => LoginPage(),
  "register": (context) => RegisterPage(),
  "chat": (context) => ChatPage(),
  "users": (context) => UsersPage(),
};
