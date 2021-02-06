import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pmdigital_app/src/pages/cumplimiento_page.dart';
import 'package:pmdigital_app/src/pages/detalleot_page.dart';
import 'package:pmdigital_app/src/pages/login_page.dart';
import 'package:pmdigital_app/src/pages/menu_page.dart';
import 'package:pmdigital_app/src/pages/operation_page.dart';
import 'package:pmdigital_app/src/pages/ordenes_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('es', 'ES'),
      ],
      title: 'PM Digital',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => LoginPage(),
        'menu': (BuildContext context) => MenuPage(),
        'ordenes': (BuildContext context) => OrdenesPage(),
        'detallesot': (BuildContext context) => DetallesOtPage(),
        'operacion': (BuildContext context) => OperacionPage(),
        'cumplimiento': (BuildContext context) => CumplimientoPage(),
      },
    );
  }
}
