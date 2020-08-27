import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pmdigital_app/src/provider/operacion_provider.dart';

class NotaPage extends StatefulWidget {
  String token;
  String idop;
  NotaPage({this.token, this.idop});

  @override
  _NotaPageState createState() => _NotaPageState();
}

class _NotaPageState extends State<NotaPage> {
  Color _appBarColor = Color(0xff354A5F);
  final notaController = TextEditingController();
  final OperacionMaterialProvider operacionMaterialProvider =
      new OperacionMaterialProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        title: Text(""),
      ),
      body: Stack(
        children: [
          cuerpoNota(),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 60,
                  width: double.infinity,
                  child: _options(context)),
            ),
          )
        ],
      ),
    );
  }

  void guardarNota() async {
    var resp = await operacionMaterialProvider.guardarNota(
        widget.token, widget.idop, notaController.text);
    if (resp['code'] == 200) {
      toast('La nota ha sido guardada exitosamente');
    }
  }

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 14.0);
  }

  Widget _options(BuildContext context) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                child: Text(
                  'Guardar',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Color(0xff0A6ED1),
                onPressed: guardarNota,
              ),
              FlatButton(
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xff0A6ED1)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget cuerpoNota() {
    Widget cabecera = Container(
      color: Colors.white,
      width: double.infinity,
      height: 50.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Text(
          'Añadir nota',
          style: TextStyle(fontSize: 20.0, fontFamily: 'fuente72'),
        ),
      ),
    );

    Widget label = Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
      child: Text(
        'Nota:',
        style: TextStyle(fontSize: 14.0, fontFamily: 'fuente72'),
      ),
    );
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cabecera,
          label,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: 48,
              child: TextFormField(
                controller: notaController,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Escriba Aquí',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
