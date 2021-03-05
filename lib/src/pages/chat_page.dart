import 'dart:io';

import 'package:chat_app/src/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _isWritting = false;

  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              CircleAvatar(
                child: Text('Te', style: TextStyle(fontSize: 16)),
                backgroundColor: Colors.blue[100],
              ),
              SizedBox(width: 15),
              Text('Roberto Gómez', style: TextStyle(color: Colors.black87, fontSize: 16))
            ],
          ),
          elevation: 1,
        ),
        body: Container(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  itemBuilder: (_, i) => _messages[i],
                  reverse: true,
                )
              ),
              Divider(height: 1),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: _inputChat(),
              )
            ],
          ),
        )
      ),
    );
  }

  Widget _inputChat() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (String texto) {
                setState(() {
                  if (texto.trim().length > 0) {
                    _isWritting = true;
                  } else {
                    _isWritting = false;
                  }
                });

              },
              decoration: InputDecoration.collapsed(
                hintText: 'Enviar Mensaje',
                hintStyle: TextStyle(color: Colors.black87)
              ),
              focusNode: _focusNode,
            )
          ),
          // Botón de enviar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
              ? CupertinoButton(
                  child: Text('Enviar'),
                  onPressed: () {}
                  )
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconTheme(
                    data: IconThemeData(color: Colors.blue[400]),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.send),
                      onPressed: _isWritting
                        ? () {}
                        : null
                      ,
                    ),
                  ),
                )
          )
        ],
      ),
    );
  }

  _handleSubmit(String texto) {
    if(texto.length == 0) return;

    _textController.clear();

    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: '1',
      texto: texto,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200)
      ),
    );

    _messages.insert(0, newMessage);

    newMessage.animationController.forward();

    setState(() {
      _isWritting = false;
    });
  }

  @override
  void dispose() {
    // TODO: Off del Socket

    // Limpieza de animation controllers creados
    for(ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}
