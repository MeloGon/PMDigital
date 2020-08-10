import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pmdigital_app/src/widgets/loginbg_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color _colorBlueApp = Color(0xff0A6ED1);
  TextStyle _styleTitle = TextStyle(
      fontSize: 40,
      fontFamily: 'fuente72',
      color: Color(0xff0A6ED1),
      fontWeight: FontWeight.w100);
  TextStyle _styleLabel = TextStyle(
    fontSize: 14.0,
    fontFamily: 'fuente72',
  );
  bool stateCheck = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            LoguinBackground(),
            _loguinCard(context),
            _textoCopy(),
          ],
        ),
      ),
    );
  }

  Widget _loguinCard(BuildContext context) {
    Widget sizedBox1 = SizedBox(
      height: 40,
    );

    Widget card = Card(
      elevation: 20.0,
      child: Form(
          child: Column(
        children: [
          sizedBox1,
          Text(
            'PM Digital',
            style: _styleTitle,
          ),
          sizedBox1,
          _labelCard('Usuario:'),
          _inputUserCard(),
          SizedBox(
            height: 20.0,
          ),
          _labelCard('Contraseña:'),
          _inputPassCard(),
          _rememberCheck(),
          sizedBox1,
          _enterButton(),
        ],
      )),
    );
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 450,
        margin: EdgeInsets.only(top: 60.0, left: 15.0, right: 15.0),
        child: card,
      ),
    );
  }

  Widget _labelCard(String label) {
    return Container(
      padding: EdgeInsets.only(left: 55.0),
      width: double.infinity,
      child: Text(
        label.toString(),
        style: _styleLabel,
      ),
    );
  }

  Widget _inputUserCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 55),
      height: 48,
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
      ),
    );
  }

  Widget _inputPassCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 55),
      height: 48,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
      ),
    );
  }

  Widget _enterButton() {
    Widget button = RaisedButton(
      onPressed: () {
        Navigator.pushNamed(context, 'menu');
      },
      color: _colorBlueApp,
      child: Text(
        'Iniciar Sesion',
        style: TextStyle(color: Colors.white),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 55.0),
      width: double.infinity,
      child: button,
    );
  }

  Widget _textoCopy() {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      alignment: Alignment.bottomCenter,
      child: Text(
        '© 2020 Innovadis | Todos los derechos reservados',
      ),
    );
  }

  Widget _rememberCheck() {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: CheckboxListTile(
        title: Text(
          "Recuerdame",
          style: _styleLabel,
        ),
        value: stateCheck,
        onChanged: (newValue) {
          setState(() {
            stateCheck = newValue;
          });
        },
        controlAffinity:
            ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
    );
  }
}
