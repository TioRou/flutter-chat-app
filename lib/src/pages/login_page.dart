import 'package:chat_app/src/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Email',
            textController: emailController,
            keyboardType: TextInputType.emailAddress
          ),
          SizedBox(height: 25),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            textController: passwordController,
            isPassword: true,
          ),
          SizedBox(height: 25),
          CustomElevatedButton(controller: emailController, texto: 'Ingresar')
        ],
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