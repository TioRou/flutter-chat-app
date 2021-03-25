import 'dart:io';
import 'package:chat_app/src/models/mensajes_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

import 'package:chat_app/src/service/auth_service.dart';
import 'package:chat_app/src/service/socket_service.dart';
import 'package:chat_app/src/widgets/chat_message.dart';
import 'package:chat_app/src/service/chat_service.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _isWritting = false;

  List<ChatMessage> _messages = [];

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  @override
  void initState() {
    super.initState();

    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', _escucharMensajeController);

    _cargarHistorial(chatService.usuarioPara.uid);
  }

  void _escucharMensajeController(dynamic payload) {
    ChatMessage newMessage = new ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300))
    );


    setState(() {
      this._messages.insert(0, newMessage);
    });

    newMessage.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 10,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                child: Text(usuarioPara.nombre.substring(0,2), style: TextStyle(fontSize: 16)),
                backgroundColor: Colors.blue[100],
              ),
              SizedBox(width: 15),
              Text(usuarioPara.nombre, style: TextStyle(color: Colors.black87, fontSize: 16))
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
      uid: authService.usuario.uid,
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

    this.socketService.socket.emit('mensaje-personal', {
      'de'      : this.authService.usuario.uid,
      'para'    : this.chatService.usuarioPara.uid,
      'mensaje' : texto
    });
  }

  @override
  void dispose() {
    // Limpieza de animation controllers creados
    for(ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    // Off del Socket
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  void _cargarHistorial(String usuarioId) async {
    List<Mensaje> mensajes = await this.chatService.getChatMessages(usuarioId);

    final historialMensajes = mensajes.map((m) => new ChatMessage(
      texto: m.mensaje,
      uid: m.de,
      animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward(),
    ));
    
    setState(() {
      this._messages.insertAll(0, historialMensajes);
    });
  }
}
