import 'package:chat_app/src/helpers/mostrar_alerta.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {

  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final String origen;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput({
    @required this.icon,
    @required this.placeholder,
    @required this.textController,
    @required this.origen,
    this.keyboardType = TextInputType.text,
    this.isPassword = false
    });

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 5),
                  blurRadius: 5
              ),
            ]
        ),
        child: TextFormField(
          controller: this.textController,
          textAlignVertical: TextAlignVertical.center,
          autocorrect: false,
          keyboardType: this.keyboardType,
          obscureText: this.isPassword,
          decoration: InputDecoration(
              prefixIcon: Icon(this.icon),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: this.placeholder
          ),
          validator: (value) {
            if (value.isEmpty) {
              if(this.placeholder == 'Email') {
                return '     Introduzca email';
              } else if(this.placeholder == 'Password'){
                return '     Introduzca password';
              } else if(this.placeholder == 'Nombre Usuario') {
                return '     Introduzca nombre de usuario';
              }
            }

            if(this.placeholder == 'Email' && !value.contains('@')) {
              return '     Introduzca un email valido';
            }

            if(this.placeholder == 'Password' && this.origen == 'Register') {
              final String str = value;
              final RegExp regExp1 = new RegExp('[a-z]');
              final bool match1 = regExp1.hasMatch(str);

              final RegExp regExp2 = new RegExp('[A-Z]');
              final bool match2 = regExp2.hasMatch(str);

              final RegExp regExp3 = new RegExp('[0-9]');
              final bool match3 = regExp3.hasMatch(str);

              final RegExp regExp4 = new RegExp('[!@#%&():;<>/=?]');
              final bool match4 = regExp4.hasMatch(str);

              if (!match1 || !match2 || !match3 || !match4 || str.length < 8) {
                mostrarAlerta(context, 'La password debe contener al menos:',
                  '1 número\n1 mayúscula\n1 minúscula\n1 carácter especial (!@#%&():;<>/=?)\nY debe tener, al menos, 8 caracteres' );
                return '     Introduzca una password valida';
              }

            }

            return null;
          },
        )
    );
  }
}
