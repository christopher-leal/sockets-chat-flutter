import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController animationController;
  const ChatMessage({Key key, @required this.text, @required this.uid, @required this.animationController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
        child: Container(
          child: uid == _authService.user.id ? _MyMessage(text: text) : _IncomingMessage(text: text),
        ),
      ),
    );
  }
}

class _IncomingMessage extends StatelessWidget {
  const _IncomingMessage({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 50, bottom: 10),
          decoration: BoxDecoration(color: Color(0xffe4e5e8), borderRadius: BorderRadius.circular(16.0)),
          padding: EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(color: Colors.black87),
          ),
        ));
  }
}

class _MyMessage extends StatelessWidget {
  const _MyMessage({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(left: 50, right: 10, bottom: 10),
          decoration: BoxDecoration(color: Color(0xff4d9ef6), borderRadius: BorderRadius.circular(16.0)),
          padding: EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}
