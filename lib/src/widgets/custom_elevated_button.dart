import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Function onPressed;
  final String texto;

  const CustomElevatedButton({
    @required this.onPressed,
    @required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text(this.texto, style: TextStyle(fontSize: 17)),
        style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: StadiumBorder(),
            minimumSize: Size(double.infinity, 55)
        ),
        onPressed: onPressed,
    );
  }
}
