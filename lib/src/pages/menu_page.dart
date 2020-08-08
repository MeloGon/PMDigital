import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:ui';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Color _colorGradbeg = Color(0xffDFE3E4);
  Color _colorGradend = Color(0xffF3F4F5);
  Color _colorTitleItems = Color(0xff32363A);
  TextStyle _titleStyle = TextStyle(
      fontSize: 24.0,
      fontFamily: 'fuente72',
      color: Color(0xff32363A),
      fontWeight: FontWeight.normal);
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
          _roundButtonStatus(_colorTitleItems, Icons.border_all,
              'Estatus de ordenes para hoy'),
          _roundButtonWeek(_colorTitleItems, Icons.directions_bus,
              'Cumplimiento del programa semanal'),
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
          _roundButtonUT(
              _colorTitleItems, Icons.border_all, 'Ubicaciones Tecnicas'),
          _roundButtonTeams(_colorTitleItems, Icons.directions_bus, 'Equipos'),
        ]),
        // TableRow(children: [
        //   _crearBotonRedondeado(Colors.pinkAccent, Icons.shop, 'Buy'),
        //   _crearBotonRedondeado(Colors.orange, Icons.insert_drive_file, 'File'),
        // ]),
      ],
    );
  }

  Widget _roundButtonStatus(Color color, IconData icono, String texto) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(texto,
                  style: TextStyle(
                      color: color, fontFamily: 'fuente72', fontSize: 16.0)),
            ),
            SizedBox(height: 5.0),
            Text('Pendiente'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: LinearPercentIndicator(
                width: 140.0,
                lineHeight: 8.0,
                percent: 0.11,
                backgroundColor: Colors.grey[200],
                progressColor: Colors.red,
              ),
            ),
            Text('En Progreso'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: LinearPercentIndicator(
                width: 140.0,
                lineHeight: 8.0,
                percent: 0.19,
                backgroundColor: Colors.grey[200],
                progressColor: Colors.deepOrange[300],
              ),
            ),
            Text('Completadas     70%'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: LinearPercentIndicator(
                width: 140.0,
                lineHeight: 8.0,
                percent: 0.7,
                backgroundColor: Colors.grey[200],
                progressColor: Colors.green,
              ),
            ),
            SizedBox(height: 5.0)
          ],
        ),
      ),
    );
  }

  Widget _roundButtonWeek(Color color, IconData icono, String texto) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(texto,
                  style: TextStyle(
                      color: color, fontFamily: 'fuente72', fontSize: 16.0)),
            ),
            SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 5.0,
                percent: 0.81,
                center: new Text("81%"),
                progressColor: Colors.blue[300],
              ),
            ),
            SizedBox(height: 5.0)
          ],
        ),
      ),
    );
  }

  Widget _roundButtonUT(Color color, IconData icono, String texto) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(texto,
                  style: TextStyle(
                      color: color, fontFamily: 'fuente72', fontSize: 16.0)),
            ),
            SizedBox(height: 5.0),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 35.0,
              child: Image(image: AssetImage('assets/images/tool_image.png')),
            ),
            SizedBox(height: 5.0)
          ],
        ),
      ),
    );
  }

  Widget _roundButtonTeams(Color color, IconData icono, String texto) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(texto,
                  style: TextStyle(
                      color: color, fontFamily: 'fuente72', fontSize: 16.0)),
            ),
            SizedBox(height: 5.0),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 35.0,
              child: Image(image: AssetImage('assets/images/tool_image2.png')),
            ),
            SizedBox(height: 5.0)
          ],
        ),
      ),
    );
  }
}
