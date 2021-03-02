import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  final ImageProvider<Object> imagenLogo;
  final Text texto;

  const CustomLogo({
    Key key,
    @required this.imagenLogo,
    @required this.texto
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width: 170,
          //margin: EdgeInsets.only(top:20),
          child: Column(
            children: [
              Image(image: this.imagenLogo),
              SizedBox(height: 20),
              this.texto,
            ],
          ),
        )
    );
  }
}