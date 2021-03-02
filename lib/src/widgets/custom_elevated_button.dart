import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final TextEditingController controller;
  final String texto;

  const CustomElevatedButton({
    Key key,
    @required this.controller,
    @required this.texto
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text(this.texto, style: TextStyle(fontSize: 17)),
        style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: StadiumBorder(),
            minimumSize: Size(double.infinity, 55)
        ),
        onPressed: () {
          print(this.controller.text);
        }
    );
  }
}
