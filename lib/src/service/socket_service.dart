import 'package:flutter/material.dart';
import 'package:chat_app/src/global/environment.dart';
import 'package:chat_app/src/service/auth_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;

  void connect() async {
    final token = await AuthService.getToken();

    // Dart client
    this._socket = IO.io(
        Environment.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            .enableForceNew()
            .setExtraHeaders( {'x-token' : token} )
            .build());

    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // this._socket.on('nuevo-mensaje', (payload) {
    //   print('nombre: ${payload['nombre']}');
    //   print('nuevo mensaje: ${payload['mensaje1']}');
    // });
    //
    // this._socket.on('emitir-mensaje', (payload) {
    //   print('nombre: ${payload['nombre']}');
    //   print('nuevo mensaje: ${payload['mensaje']}');
    // });

  }

  void disconnect() {
    this.socket.disconnect();
  }
}