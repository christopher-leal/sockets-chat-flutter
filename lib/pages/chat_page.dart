import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/services/auth_service.dart';
import 'package:realtime_chat/services/chat_service.dart';
import 'package:realtime_chat/services/socket_service.dart';
import 'package:realtime_chat/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _chatController = TextEditingController();
  final _focusNode = FocusNode();

  List<ChatMessage> _messages = [];
  bool _isTyping = false;
  SocketService _socketService;
  AuthService _authService;
  ChatService _chatService;

  @override
  void initState() {
    _socketService = Provider.of<SocketService>(context, listen: false);
    _authService = Provider.of<AuthService>(context, listen: false);
    _chatService = Provider.of<ChatService>(context, listen: false);

    _socketService.socket.on('message', receiveMessage);
    _loadMessages();
    super.initState();
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    _socketService.socket.off('message');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
          title: Column(
            children: [
              CircleAvatar(
                child: Text(
                  _chatService.userTo.name.substring(0, 2),
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blueAccent,
                maxRadius: 15,
              ),
              SizedBox(height: 3),
              Text(
                _chatService.userTo.name,
                style: TextStyle(color: Colors.black87, fontSize: 12),
              )
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                physics: BouncingScrollPhysics(),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              )),
              Divider(),
              Container(
                color: Colors.white,
                height: 50,
                child: _inputChat(),
              )
            ],
          ),
        ));
  }

  Widget _inputChat() => SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Flexible(
                  child: TextField(
                controller: _chatController,
                decoration: InputDecoration.collapsed(hintText: 'Send message'),
                focusNode: _focusNode,
                onSubmitted: _handleSubmit,
                onChanged: (value) {
                  setState(() {
                    _isTyping = (value.trim().length > 0) ? true : false;
                  });
                },
              )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Platform.isIOS
                      ? CupertinoButton(
                          child: Icon(Icons.send),
                          onPressed: _isTyping ? () => _handleSubmit(_chatController.text.trim()) : null,
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: IconTheme(
                            data: IconThemeData(color: Colors.blue[400]),
                            child: IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              icon: Icon(Icons.send),
                              onPressed: _isTyping ? () => _handleSubmit(_chatController.text.trim()) : null,
                            ),
                          ),
                        )),
            ],
          ),
        ),
      );

  _handleSubmit(String text) {
    if (text.length == 0) return;
    _chatController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      text: text,
      uid: _authService.user.id,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );

    newMessage.animationController.forward();
    setState(() {
      _messages.insert(0, newMessage);
      _isTyping = false;
    });

    _socketService.emit('message', {'from': _authService.user.id, 'to': _chatService.userTo.id, 'message': text});
  }

  receiveMessage(dynamic data) {
    print(data);
    ChatMessage message = ChatMessage(
        text: data['message'], uid: data['from'], animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)));
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  void _loadMessages() async {
    await _chatService.getMessages(_chatService.userTo.id);

    setState(() {
      _messages = _chatService.messages
          .map((message) => ChatMessage(
              text: message.message,
              uid: message.from,
              animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200))..forward()))
          .toList();
    });
  }
}
