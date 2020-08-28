import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImagePage extends StatefulWidget {
  final File foto;
  final String token;
  final String idot;
  ImagePage(this.foto, this.token, this.idot);
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
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
              onPressed: () =>
                  guardarFoto(widget.foto, widget.token, widget.idot, context))
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
      File foto, String token, String idot, BuildContext context) async {
    Fluttertoast.showToast(
        msg: "Guardando fotografia ...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 14.0);
    // var rsp = await subirFoto(foto, token, idot);
    // if (rsp.data['code'] == 200 || rsp.data['code'] == "200") {
    //   showDialog<String>(
    //       context: context,
    //       builder: (BuildContext context) => new AlertDialog(
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.all(Radius.circular(4.0))),
    //             content: Builder(
    //               builder: (context) {
    //                 return Container(
    //                   child: Text(
    //                     'La fotografia ha sido guardada exitosamente. Regresa a la galeria y actualiza para ver los cambios',
    //                     style: TextStyle(fontFamily: 'fuente72'),
    //                     textAlign: TextAlign.center,
    //                   ),
    //                 );
    //               },
    //             ),
    //           ));
    //   Future.delayed(const Duration(milliseconds: 1100), () {
    //     setState(() {
    //       Navigator.pop(context);
    //       Navigator.pop(context);
    //     });
    //   });
    // } else {
    //   print('algo malo paso');
    // }
  }
}
