
import 'package:http/http.dart' as http;

import 'package:chat_app/src/models/usuarios_response.dart';
import 'package:chat_app/src/global/environment.dart';
import 'package:chat_app/src/models/usuario.dart';
import 'package:chat_app/src/service/auth_service.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try{
      final Uri uri = Uri.parse('${Environment.apiUrl}/usuarios/');

      final resp = await http.get(uri,
          headers: {
            'Content-Type': 'application/json',
            'x-token'     : await AuthService.getToken()
          }
      );

      final usuariosResponse = usuariosResponseFromJson(resp.body);

      return usuariosResponse.usuarios;

    } catch(e) {

    }
  }
}