import 'package:chat_app/src/models/ko_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:chat_app/src/models/usuario.dart';
import 'package:chat_app/src/models/login_response.dart';
import 'package:chat_app/src/global/environment.dart';

class AuthService with ChangeNotifier {

  // Create storage
  final _storage = new FlutterSecureStorage();

  // Getter & Delete del token de forma estática
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Usuario usuario;
  bool _autenticando = false;
  bool _registrando = false;

  bool get autenticando => this._autenticando;
  set autenticando(bool value) {
    this._autenticando = value;
    notifyListeners();
  }

  bool get registrando => this._registrando;
  set registrando(bool value) {
    this._registrando = value;
    notifyListeners();
  }


  Future<Map<String, dynamic>> login(String email, String password) async {
    this.autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final Uri uri = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    print(resp.body);

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return {'ok' : true};
    } else {
      final koResponse = koResponseFromJson(resp.body);

      return {
        'ok'  : false,
        'msg' : koResponse.msg
      };
    }

  }

  Future<Map<String, dynamic>> register(String nombre, String email, String password) async {
    this.registrando = true;

    final data = {
      'nombre'  : nombre,
      'email'   : email,
      'password': password
    };

    final Uri uri = Uri.parse('${Environment.apiUrl}/login/new');

    final resp = await http.post(uri,
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json'
        }
    );

    print(resp.body);

    this.registrando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return {'ok' : true};
    } else {
      final koResponse = koResponseFromJson(resp.body);

      return {
        'ok'  : false,
        'msg' : koResponse.msg
      };
    }

  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    //final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI2MDQ2NzAxN2MzMmRkYzMxODU1OWFjMmQiLCJpYXQiOjE2MTYzMjYxOTcsImV4cCI6MTYxNjQxMjU5N30.C7Wq4HdzWbSuZ6vorq50CSyItDDvz32KpBldwApe8bM';
    final Uri uri = Uri.parse('${Environment.apiUrl}/login/renew');

    final resp = await http.get(uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token'     : token
        }
    );

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      this._logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    await _storage.delete(key: 'token');
  }


}