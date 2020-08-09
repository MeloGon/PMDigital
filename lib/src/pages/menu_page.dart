import 'package:flutter/material.dart';

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
  Color _appBarColor = Color(0xff354A5F);
  Color _subtitleColor = Color(0xff6A6D70);
  TextStyle _titleStyle = TextStyle(
      fontSize: 24.0,
      fontFamily: 'fuente72',
      color: Color(0xff32363A),
      fontWeight: FontWeight.normal);

  TextStyle _titleCardStyle = TextStyle(
      fontSize: 16.0,
      fontFamily: 'fuente72',
      color: Color(0xff32363A),
      fontWeight: FontWeight.normal);

  List<BoxShadow> _shadowsCards = [
    BoxShadow(
      color: Colors.black26,
      offset: Offset(0.0, 1.0), //(x,y)
      blurRadius: 10.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Inicio'),
          backgroundColor: _appBarColor,
          actions: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20.0,
              child: Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            _loguinBg(),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _titulos("Ordenes de Trabajo"),
                  _botonesRedondeadosOT(),
                  _titulos("Activos"),
                  _botonesRedondeadosAT()
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
        padding: EdgeInsets.only(top: 15.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(titleValue.toString(), style: _titleStyle),
          ],
        ),
      ),
    );
  }

  Widget _botonesRedondeadosOT() {
    return Table(
      children: [
        TableRow(children: [
          _roundButtonStatus(_colorTitleItems, Icons.border_all,
              'Estatus de ordenes para hoy'),
          _roundButtonWeek(
              _colorTitleItems, 'Cumplimiento del programa semanal'),
        ]),
      ],
    );
  }

  Widget _botonesRedondeadosAT() {
    return Table(
      children: [
        TableRow(children: [
          roundButtonAT(_colorTitleItems, 'assets/images/tool_image.png',
              'Ubicaciones Tecnicas'),
          roundButtonAT(
              _colorTitleItems, 'assets/images/tool_image2.png', 'Equipos'),
        ]),
      ],
    );
  }

  Widget roundButtonAT(Color color, String icon, String texto) {
    Widget iconRb = Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Image(
        image: AssetImage(icon.toString()),
        width: 30.0,
        height: 50.0,
      ),
    );

    Widget contentRb = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(texto, style: _titleCardStyle),
        ),
        iconRb,
        SizedBox(height: 5.0)
      ],
    );

    return ClipRect(
      child: Container(
        height: 180.0,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: _shadowsCards,
        ),
        child: contentRb,
      ),
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

  Widget _roundButtonWeek(Color color, String texto) {
    Widget valueProgressCircular = Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 5.0,
        percent: 0.81,
        center: new Text("81%"),
        progressColor: Colors.blue[300],
      ),
    );

    Widget contentRb = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(texto, style: _titleCardStyle),
        ),
        // Text('2020W31',style: TextStyle(fontFamily: 'fuente72',color: _subtitleColor,),),
        valueProgressCircular,
        SizedBox(height: 5.0)
      ],
    );

    return ClipRect(
      child: Container(
        height: 180.0,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: _shadowsCards,
        ),
        child: contentRb,
      ),
    );
  }
}
