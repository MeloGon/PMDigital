import 'package:flutter/material.dart';
import 'package:pmdigital_app/src/pages/login_page.dart';
import 'package:pmdigital_app/src/pages/menu_page.dart';
import 'package:pmdigital_app/src/pages/ordenes_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PM Digital',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => LoginPage(),
        'menu': (BuildContext context) => MenuPage(),
        'ordenes': (BuildContext context) => OrdenesPage(),
      },
    );
  }
}
