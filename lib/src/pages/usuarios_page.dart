import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/src/service/chat_service.dart';
import 'package:chat_app/src/service/usuarios_service.dart';
import 'package:chat_app/src/service/socket_service.dart';
import 'package:chat_app/src/service/auth_service.dart';
import 'package:chat_app/src/models/usuario.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuariosService = new UsuariosService();
  List<Usuario> usuariosDB = [];

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(usuario.nombre, style: TextStyle(color: Colors.black87),),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.black87,),
            onPressed: () {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.blue[400],)
                : Icon(Icons.offline_bolt, color: Colors.red[400],),
            ),
          ],
        ),
        body: SmartRefresher(
            child: _usuariosListView(),
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: _cargarUsuarios,
        )
      ),
    );
  }

  ListView _usuariosListView() {
    return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, i) => _usuarioListTile(usuariosDB[i]),
          separatorBuilder: (_, i) => Divider(),
          itemCount: usuariosDB.length
      );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
            title: Text(usuario.nombre),
            subtitle: Text(usuario.email),
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(usuario.nombre.substring(0,2))
            ),
            trailing: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: usuario.online ? Colors.green[300] : Colors.red,
                borderRadius: BorderRadius.circular(100)
              ),
            ),
            onTap: () {
              final chatService = Provider.of<ChatService>(context, listen: false);
              chatService.usuarioPara = usuario;

              Navigator.pushNamed(context, 'chat');
            },
          );
  }

  _cargarUsuarios() async {
    this.usuariosDB = await usuariosService.getUsuarios();
    setState(() {});

    _refreshController.refreshCompleted();
  }
}
