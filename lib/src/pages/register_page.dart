import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/src/service/socket_service.dart';
import 'package:chat_app/src/helpers/mostrar_alerta.dart';
import 'package:chat_app/src/widgets/custom_input.dart';
import 'package:chat_app/src/service/auth_service.dart';
import 'package:chat_app/src/widgets/custom_label.dart';
import 'package:chat_app/src/widgets/custom_logo.dart';
import 'package:chat_app/src/widgets/custom_elevated_button.dart';

class RegisterPage extends StatelessWidget {
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
                    texto: Text('Registro', style: TextStyle(fontSize: 30))
                ),
                _Form(),
                CustomLabel(
                    texto1: 'Ya tienes cuenta?',
                    texto2: 'Entra con tu cuenta',
                    route: 'login'
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
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKeyRegister = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: _formKeyRegister,
        child: Column(
          children: [
            CustomInput(
                icon: Icons.perm_identity,
                placeholder: 'Nombre Usuario',
                textController: nameController,
                origen: 'Register',
            ),
            SizedBox(height: 25),
            CustomInput(
                icon: Icons.email_outlined,
                placeholder: 'Email',
                textController: emailController,
                origen: 'Register',
                keyboardType: TextInputType.emailAddress
            ),
            SizedBox(height: 25),
            CustomInput(
              icon: Icons.lock_outline,
              placeholder: 'Password',
              textController: passwordController,
              origen: 'Register',
              isPassword: true,
            ),
            SizedBox(height: 25),
            CustomElevatedButton(
              onPressed: authService.registrando ? null : () async {
                if(_formKeyRegister.currentState.validate()) {
                  FocusScope.of(context).unfocus();
                  final registroOK = await authService.register(nameController.text.trim(), emailController.text.trim(), passwordController.text.trim());

                  if (registroOK['ok']) {
                    socketService.connect();

                    Navigator.pushReplacementNamed(context, 'usuarios');
                  } else {
                    mostrarAlerta(context, 'Error Login', registroOK['msg']);
                  }
                }

              },
              texto: 'Registrarse',
            )
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
