import 'dart:io';
import 'dart:typed_data';

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
  var byteArray;

  @override
  void initState() {
    byteArray = _readFileByte(widget.foto.path);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.foto.path);
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
        child: Container(
          height: double.infinity,
          child: Image.file(File(widget.foto.path)),
        ),
        /* child: Image(
          image: AssetImage(widget.foto.path),
          height: 300.0,
          fit: BoxFit.cover,
        ), */
      ),
    );
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = new File.fromUri(myUri);
    Uint8List bytes;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }

  guardarFoto(
      File foto, String token, String idop, BuildContext context) async {
    var rsp = await operacionMaterialProvider.subirImagen(foto);
    var rsp1 =
        await operacionMaterialProvider.subirImagenServer(token, idop, rsp);
    Navigator.pop(context);
  }
}
