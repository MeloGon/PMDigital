import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pmdigital_app/src/widgets/loginbg_widget.dart';
import 'package:pmdigital_app/src/widgets/roundbt_widget.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Color _appBarColor = Color(0xff354A5F);
  // Color _subtitleColor = Color(0xff6A6D70);
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

  TextStyle _labelPercentStyle = TextStyle(
      fontSize: 12.0,
      fontFamily: 'fuente72',
      color: Color(0xff32363A),
      fontWeight: FontWeight.normal);

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
            LoguinBackground(),
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
    // cuando recibamos datos ponerlos como globales y añadir la funcion del color dinamico de acuerdo al progreso
    var x = 0.11;
    var y = 0.19;
    var z = 0.7;

    Widget linePercent = linearPercent(x, Colors.red);
    Widget linePercent1 = linearPercent(y, Colors.deepOrange[300]);
    Widget linePercent2 = linearPercent(z, Colors.green);

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

    Widget contentWe = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child:
              Text('Cumplimiento del programa semanal', style: _titleCardStyle),
        ),
        // Text('2020W31',style: TextStyle(fontFamily: 'fuente72',color: _subtitleColor,),),
        valueProgressCircular,
        SizedBox(height: 5.0)
      ],
    );

    Widget contentSt = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Estatus de ordenes para hoy', style: _titleCardStyle),
            Text('Pendientes         11%', style: _labelPercentStyle),
            linePercent,
            Text('En progreso        19%', style: _labelPercentStyle),
            linePercent1,
            Text('Completadas      70%', style: _labelPercentStyle),
            linePercent2,
            SizedBox(height: 5.0)
          ],
        ));

    return Table(
      children: [
        TableRow(children: [
          RoundButtonWidget(
            contentRb: contentSt,
            actionRb: 1,
          ),
          RoundButtonWidget(
            contentRb: contentWe,
            actionRb: 2,
          ),
        ]),
      ],
    );
  }

  Widget linearPercent(double percent, Color color) {
    return LinearPercentIndicator(
      lineHeight: 8.0,
      percent: percent,
      backgroundColor: Colors.grey[200],
      progressColor: color,
    );
  }

  Widget _botonesRedondeadosAT() {
    Widget iconUt = Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Image(
        image: AssetImage('assets/images/tool_image.png'),
        width: 30.0,
        height: 50.0,
      ),
    );

    //no reutilizo el codigo por que los tamaños de las imagenes cambia por cuestiones del diseñador UI

    Widget iconTe = Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Image(
        image: AssetImage('assets/images/tool_image2.png'),
        width: 37.0,
        height: 50.0,
      ),
    );

    Widget contentUt = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Ubicaciones Tecnicas', style: _titleCardStyle),
        ),
        iconUt,
        SizedBox(height: 5.0)
      ],
    );

    Widget contentTe = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Equipos', style: _titleCardStyle),
        ),
        iconTe,
        SizedBox(height: 5.0)
      ],
    );

    return Table(
      children: [
        TableRow(children: [
          RoundButtonWidget(
            contentRb: contentUt,
            actionRb: 3,
          ),
          RoundButtonWidget(
            contentRb: contentTe,
            actionRb: 4,
          ),
        ]),
      ],
    );
  }
}
