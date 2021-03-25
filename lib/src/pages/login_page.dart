import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/src/widgets/custom_elevated_button.dart';
import 'package:chat_app/src/service/auth_service.dart';
import 'package:chat_app/src/service/socket_service.dart';
import 'package:chat_app/src/helpers/mostrar_alerta.dart';
import 'package:chat_app/src/widgets/custom_input.dart';
import 'package:chat_app/src/widgets/custom_label.dart';
import 'package:chat_app/src/widgets/custom_logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.97,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomLogo(
                  imagenLogo: AssetImage('assets/tag-logo.png'),
                  texto: Text('Messenger', style: TextStyle(fontSize: 30))
                ),
                _Form(),
                CustomLabel(
                  texto1: 'No tienes cuenta?',
                  texto2: 'Crea una cuenta ahora',
                  route: 'register'
                ),
                _Footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKeyLogin = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: _formKeyLogin,
        child: Column(
          children: [
            CustomInput(
              icon: Icons.email_outlined,
              placeholder: 'Email',
              textController: emailController,
              origen: 'Login',
              keyboardType: TextInputType.emailAddress
            ),
            SizedBox(height: 25),
            CustomInput(
              icon: Icons.lock_outline,
              placeholder: 'Password',
              textController: passwordController,
              origen: 'Login',
              isPassword: true,
            ),
            SizedBox(height: 25),
            CustomElevatedButton(
              onPressed: authService.autenticando ? null : () async {
                if(_formKeyLogin.currentState.validate()) {
                  FocusScope.of(context).unfocus();
                  final loginOK = await authService.login(emailController.text.trim(), passwordController.text.trim());

                  if (loginOK['ok']) {
                    socketService.connect();

                    Navigator.pushReplacementNamed(context, 'usuarios');
                  } else {
                    mostrarAlerta(context, 'Error Login', loginOK['msg']);
                  }
                }
              },
              texto: 'Ingresar')
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Text(
        'Términos y condiciones de uso',
        style: TextStyle(fontWeight: FontWeight.w200),
      ),
    );
  }
}

/// blocks rotation; sets orientation to: portrait
void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
