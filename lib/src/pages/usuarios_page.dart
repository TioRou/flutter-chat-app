import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/src/service/auth_service.dart';
import 'package:chat_app/src/models/usuario.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuarios = [
    Usuario(uid: '1', nombre: 'María', email: 'test1@test.com', online: true),
    Usuario(uid: '2', nombre: 'Roberto', email: 'test2@test.com', online: false),
    Usuario(uid: '3', nombre: 'Marc', email: 'test3@test.com', online: true),
  ];

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
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
              //TODO: Desconectar del socket server
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(Icons.check_circle, color: Colors.blue[400],),
              //child: Icon(Icons.offline_bolt, color: Colors.red[400],),
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
          itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
          separatorBuilder: (_, i) => Divider(),
          itemCount: usuarios.length
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
          );
  }

  _cargarUsuarios() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
