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
                  Navigator.pop(context);
                },
                child: Text(
                  "Cerrar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              FlatButton(
                  onPressed: () async {
                    Fluttertoast.showToast(
                        msg: "Eliminando fotografia...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 14.0);
                    var resp = await operacionMaterialProvider.eliminarFoto(
                        token, idfoto);
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
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
