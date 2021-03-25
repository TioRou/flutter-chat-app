import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/src/models/mensajes_response.dart';
import 'package:chat_app/src/global/environment.dart';
import 'package:chat_app/src/service/auth_service.dart';

import 'package:chat_app/src/models/usuario.dart';

class ChatService with ChangeNotifier {
  Usuario usuarioPara;

  Future<List<Mensaje>> getChatMessages(String usuarioId) async {

    final Uri uri = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioId');

    final resp = await http.get(uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token'     : await AuthService.getToken()
        }
    );

    final mensajesResponse = mensajesResponseFromJson(resp.body);

    return mensajesResponse.mensajes;

  }
}