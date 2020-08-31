import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pmdigital_app/src/widgets/loginbg_widget.dart';
import 'package:pmdigital_app/src/widgets/roundbt_widget.dart';

class MenuPage extends StatefulWidget {
  final String token;
  MenuPage({this.token});
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Color _appBarColor = Color(0xff354A5F);
  // Color _subtitleColor = Color(0xff6A6D70);
  TextStyle _titleStyle = TextStyle(
      fontSize: 18.0,
      fontFamily: 'fuente72',
      color: Color(0xff32363A),
      fontWeight: FontWeight.normal);

  TextStyle _titleCardStyle = TextStyle(
      fontSize: 16.0,
      fontFamily: 'fuente72',
      color: Color(0xff32363A),
      fontWeight: FontWeight.normal);

  TextStyle _subtitleCardStyle = TextStyle(
      fontSize: 14.0,
      fontFamily: 'fuente72',
      color: Color(0xff6A6D70),
      fontWeight: FontWeight.normal);

  TextStyle _numberCardStyle = TextStyle(
      fontSize: 40.0,
      fontFamily: 'fuente72',
      color: Color(0xff6A6D70),
      fontWeight: FontWeight.normal);

  TextStyle _labelPercentStyle = TextStyle(
      fontSize: 12.0,
      fontFamily: 'fuente72',
      color: Color(0xff32363A),
      fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: PopupMenuButton<String>(
                child: Row(
                  children: <Widget>[
                    Text(
                      'Inicio',
                      style: TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "perfil",
                    child: Text(
                      "Mis órdenes hoy",
                      style: TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "cerrar_sesion",
                    child: Text(
                      "Cumplimiento del programa semanal",
                      style: TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "cerrar_sesion",
                    child: Text(
                      "Ubicaciones Tecnicas",
                      style: TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
                    ),
                  ),
                ],
                /* onSelected: (value) {
                  if (value == "cerrar_sesion") {
                    print('Menu');
                  }
                },*/
              ),
              //title: Text('Inicio',
              //style: TextStyle(fontFamily: 'fuente72', fontSize: 14.0)),
              backgroundColor: _appBarColor,
              centerTitle: false,
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
                      _titulos("Órdenes de Trabajo"),
                      _botonesRedondeadosOT(),
                      _titulos("Activos"),
                      _botonesRedondeadosAT()
                    ],
                  ),
                )
              ],
            )),
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
    Widget _valueProgressCircular = Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 5.0,
        percent: 0.81,
        center: new Text("81%"),
        progressColor: Colors.blue[300],
        backgroundColor: Colors.grey[200],
        animation: true,
        animationDuration: 1500,
      ),
    );

    Widget _contentWe = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Programa Semanal', style: _titleCardStyle),
        ),
        // Text('2020W31', style: _subtitleCardStyle),
        _valueProgressCircular,
        SizedBox(height: 5.0)
      ],
    );

    Widget _contentSt = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Mis órdenes hoy', style: _titleCardStyle),
            Text(
              'Abiertas',
              style: _subtitleCardStyle,
            ),
            Row(
              children: [
                Image(
                  image: AssetImage('assets/images/tool_image3.png'),
                  width: 30.0,
                  height: 50.0,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  '3',
                  style: _numberCardStyle,
                ),
              ],
            ),
            SizedBox(height: 5.0)
          ],
        ));

    return Table(
      children: [
        TableRow(children: [
          RoundButtonWidget(
              contentRb: _contentSt, actionRb: 1, token: widget.token),
          RoundButtonWidget(
              contentRb: _contentWe, actionRb: 2, token: widget.token),
        ]),
      ],
    );
  }

  Widget _botonesRedondeadosAT() {
    Widget _iconUt = Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Image(
        image: AssetImage('assets/images/tool_image.png'),
        width: 30.0,
        height: 50.0,
      ),
    );

    //no reutilizo el codigo por que los tamaños de las imagenes cambia por cuestiones del diseñador UI

    Widget _contentUt = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Ubicaciones Técnicas', style: _titleCardStyle),
        ),
        _iconUt,
        SizedBox(height: 5.0)
      ],
    );

    return Table(
      columnWidths: {0: FractionColumnWidth(0.5)},
      children: [
        TableRow(children: [
          RoundButtonWidget(
              contentRb: _contentUt, actionRb: 3, token: widget.token),
          SizedBox(
            height:
                188, // para la cuarta caja invisible, no existe un alignmnet para el tablerow
          )
        ]),
      ],
    );
  }
}
