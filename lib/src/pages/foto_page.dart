import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pmdigital_app/src/provider/operacion_provider.dart';

class ImagePage extends StatefulWidget {
  final File foto;
  final String token;
  final String idop;
  ImagePage(this.foto, this.token, this.idop);
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  final OperacionMaterialProvider operacionMaterialProvider =
      new OperacionMaterialProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          FlatButton(
              child: Text(
                'Guardar',
                style: TextStyle(
                    fontFamily: 'fuente72', color: Colors.white, fontSize: 15),
              ),
              onPressed: () {
                Fluttertoast.showToast(
                    msg: "Guardando fotografia ...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 14.0);
                guardarFoto(widget.foto, widget.token, widget.idop, context);
              })
        ],
      ),
      body: Center(
        child: Image(
          image: AssetImage(widget.foto.path),
          height: 300.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  guardarFoto(
      File foto, String token, String idop, BuildContext context) async {
    var rsp = await operacionMaterialProvider.subirImagen(foto);
    var rsp1 =
        await operacionMaterialProvider.subirImagenServer(token, idop, rsp);
    Navigator.pop(context);
  }
}
