import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pmdigital_app/src/pages/menu_page.dart';
import 'package:pmdigital_app/src/provider/loguin_provider.dart';
import 'package:pmdigital_app/src/provider/menu_provider.dart';
import 'package:pmdigital_app/src/widgets/loginbg_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //provider
  final LoguinProvider loguinProvider = new LoguinProvider();
  final menuprovider = MenuProvider();
  //ui styles
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
  //email tecnico2@tecnico.com  contra   111aaa
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  bool stateCheck = false;

  @override
  void initState() {
    cargarPref();
    super.initState();
  }

  cargarPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController = TextEditingController(text: prefs.get('correo'));
    passwordController = TextEditingController(text: prefs.get('pwd'));
    stateCheck = prefs.get('remem') ?? false;
    setState(() {});
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
            'Bienvenido',
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
        style: _styleLabel,
        controller: emailController,
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
        controller: passwordController,
        obscureText: true,
        style: _styleLabel,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
      ),
    );
  }

  Widget _rememberCheck() {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: CheckboxListTile(
        title: Text(
          "Recuérdame",
          style: _styleLabel,
        ),
        value: stateCheck,
        onChanged: (newValue) {
          setState(() {
            stateCheck = newValue;
            print('estado es $stateCheck');
          });
        },
        controlAffinity:
            ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
    );
  }

  Widget _enterButton() {
    Widget button = RaisedButton(
      onPressed: _loguinFuncion,
      color: _colorBlueApp,
      child: Text(
        'Iniciar sesión',
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
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(bottom: 15),
        alignment: Alignment.bottomCenter,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            '© 2020 Innovadis | Todos los derechos reservados',
          ),
        ),
      ),
    );
  }

  void _loguinFuncion() async {
    var email = emailController.text;
    var pass = passwordController.text;
    if (email.isEmpty || pass.isEmpty) {
      toast('Alguno de los campos se encuentra vacio. Intente nuevamente',
          Colors.black, Colors.white);
    } else {
      toast("Validando credenciales..", Colors.black, Colors.white);
      if (stateCheck) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('correo', emailController.text);
        prefs.setString('pwd', passwordController.text);
        prefs.setBool('remem', stateCheck);
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('correo', "");
        prefs.setString('pwd', "");
        prefs.setBool('remem', stateCheck);
      }
      var rsp = await loguinProvider.loguinUser(
          emailController.text, passwordController.text);
      // print(rsp);
      if (rsp['code'] == 200) {
        var rsp1 = await menuprovider.progresoCumpli(rsp['token']);
        toast("Credenciales validados exitosamente", Colors.white,
            Colors.blue[300]);
        //Navigator.pushNamed(context, 'menu', arguments: rsp['token']);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MenuPage(
            token: rsp['token'],
            cumplimientoMenu: rsp1,
          );
        }));
      } else {
        toast("Credenciales Invalidos. Vuelva a intentarlo porfavor.",
            Colors.white, Colors.red[300]);
      }
    }
  }

  void toast(String msg, Color colorTexto, Color colorbg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: colorbg,
        textColor: colorTexto,
        fontSize: 14.0);
  }
}
