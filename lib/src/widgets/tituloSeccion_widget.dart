import 'package:flutter/material.dart';

class TituloSeccionWidget extends StatelessWidget {
  final String value;
  TituloSeccionWidget({this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 0.1,
          ),
        ),
      ),
      child: Text(
        value,
        style: TextStyle(fontFamily: 'fuente72', fontSize: 18.0),
      ),
    );
  }
}
