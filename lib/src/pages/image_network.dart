import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pmdigital_app/src/models/OrdenFullModel.dart';
import 'package:pmdigital_app/src/provider/operacion_provider.dart';

class ImagePageNetwork extends StatelessWidget {
  final String foto;
  final String token;
  final String idfoto;
  ImagePageNetwork(this.foto, this.token, this.idfoto);
  OperacionMaterialProvider operacionMaterialProvider =
      new OperacionMaterialProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Center(
            child: Image.network(foto),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 60,
                width: double.infinity,
                child: _options(context),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _options(BuildContext context) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                color: Colors.blue[900],
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  "Cerrar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              FlatButton(
                  onPressed: () async {
                    showAlertDialog(context);
                  },
                  child: Text(
                    'Eliminar',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'fuente72',
                        color: Color(0xff0854A1)),
                  )),
            ],
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancelar",
        style: TextStyle(fontFamily: 'fuente72', fontSize: 14),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = RaisedButton(
      color: Colors.blue[900],
      child: Text("Continuar",
          style: TextStyle(fontFamily: 'fuente72', fontSize: 14)),
      onPressed: () async {
        Fluttertoast.showToast(
            msg: "Eliminando fotografia...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 14.0);
        var resp = await operacionMaterialProvider.eliminarFoto(token, idfoto);
        if (resp['code'] == 200) {
          Fluttertoast.showToast(
              msg: "Fotografia Eliminada",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 14.0);
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(
              msg: "Ups algo ha sucedido. Intentelo nuevamente",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 14.0);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmación",
          style: TextStyle(fontFamily: 'fuente72', fontSize: 18)),
      content: Text("¿ Estas seguro de que deseas eliminar la fotografia ?",
          style: TextStyle(fontFamily: 'fuente72', fontSize: 14)),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
