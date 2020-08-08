import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:ui';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Color _colorGradbeg = Color(0xffDFE3E4);
  Color _colorGradend = Color(0xffF3F4F5);
  TextStyle _titleStyle = TextStyle(fontSize: 24.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _loguinBg(),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _titulos("Ordenes de Trabajo"),
              _botonesRedondeados(),
              _titulos("Activos"),
              _botonesRedondeados1()
            ],
          ),
        )
      ],
    ));
  }

  Widget _loguinBg() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [_colorGradbeg, _colorGradend],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
    );
  }

  Widget _titulos(String titleValue) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 20.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(titleValue.toString(), style: _titleStyle),
          ],
        ),
      ),
    );
  }

  Widget _botonesRedondeados() {
    return Table(
      children: [
        TableRow(children: [
          _crearBotonRedondeado(Colors.blue, Icons.border_all, 'General'),
          _crearBotonRedondeado(
              Colors.purpleAccent, Icons.directions_bus, 'Bus'),
        ]),
        // TableRow(children: [
        //   _crearBotonRedondeado(Colors.pinkAccent, Icons.shop, 'Buy'),
        //   _crearBotonRedondeado(Colors.orange, Icons.insert_drive_file, 'File'),
        // ]),
      ],
    );
  }

  Widget _botonesRedondeados1() {
    return Table(
      children: [
        TableRow(children: [
          _crearBotonRedondeado(Colors.blue, Icons.border_all, 'General'),
          _crearBotonRedondeado(
              Colors.purpleAccent, Icons.directions_bus, 'Bus'),
        ]),
        // TableRow(children: [
        //   _crearBotonRedondeado(Colors.pinkAccent, Icons.shop, 'Buy'),
        //   _crearBotonRedondeado(Colors.orange, Icons.insert_drive_file, 'File'),
        // ]),
      ],
    );
  }

  Widget _crearBotonRedondeado(Color color, IconData icono, String texto) {
    return ClipRect(
      child: Container(
        height: 180.0,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: 5.0),
            CircleAvatar(
              backgroundColor: color,
              radius: 35.0,
              child: Icon(icono, color: Colors.white, size: 30.0),
            ),
            Text(texto, style: TextStyle(color: color)),
            SizedBox(height: 5.0)
          ],
        ),
      ),
    );
  }
}
