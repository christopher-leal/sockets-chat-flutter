import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              CircleAvatar(
                child: Text(
                  'F3',
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blueAccent,
                maxRadius: 15,
              ),
              SizedBox(height: 3),
              Text(
                'Test 1',
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
                          onPressed: _isTyping
                              ? () => _handleSubmit(_chatController.text.trim())
                              : null,
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: IconTheme(
                            data: IconThemeData(color: Colors.blue[400]),
                            child: IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              icon: Icon(Icons.send),
                              onPressed: _isTyping
                                  ? () =>
                                      _handleSubmit(_chatController.text.trim())
                                  : null,
                            ),
                          ),
                        )),
            ],
          ),
        ),
      );

  _handleSubmit(String text) {
    if (text.length == 0) return;
    print(text);
    _chatController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      text: text,
      uid: '123',
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );

    newMessage.animationController.forward();
    setState(() {
      _messages.insert(0, newMessage);
      _isTyping = false;
    });
  }
}
