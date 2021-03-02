import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final String texto1;
  final String texto2;
  final String route;

  const CustomLabel({
    Key key,
    @required this.texto1,
    @required this.texto2,
    @required this.route
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            this.texto1,
            style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            child: Text(this.texto2,
              style: TextStyle(color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: ()  => Navigator.pushNamed(context, this.route)
          )
        ],
      ),
    );
  }
}