import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:pmdigital_app/src/models/OrdenModel.dart';
import 'package:pmdigital_app/src/provider/ordenes_provider.dart';

import 'detalleot_page.dart';

class OrdenesPage extends StatefulWidget {
  final String token;
  OrdenesPage({this.token});
  @override
  _OrdenesPageState createState() => _OrdenesPageState();
}

class _OrdenesPageState extends State<OrdenesPage> {
  //Colores
  Color _appBarColor = Color(0xff354A5F);
  Color _greyColor = Color(0xff6A6D70);
  //Estilos
  TextStyle _styleText = TextStyle(fontFamily: 'fuente72', fontSize: 14.0);

  TextStyle _oTextStyle =
      TextStyle(fontFamily: 'fuente72', fontSize: 14.0, color: Colors.black);
  TextStyle _titleOtStyle = TextStyle(
      fontSize: 14.0, color: Color(0xff32363A), fontWeight: FontWeight.w700);

  TextStyle _estiloItemNro = TextStyle(
      fontSize: 16,
      fontFamily: 'fuente72',
      fontWeight: FontWeight.w700,
      color: Color(0xff0A6ED1));

  TextStyle _estiloItemDescr = TextStyle(
      fontSize: 14, fontFamily: 'fuente72', fontWeight: FontWeight.w700);

  final busController = new TextEditingController(text: "");
  OrdenesProvider ordenesProvider = new OrdenesProvider();
  List<OrdenModel> listaOrdenToda = new List<OrdenModel>();
  List<OrdenModel> listaOrdenTodaFiltrada = new List<OrdenModel>();
  List<String> cantOpyMat = [];
  TextEditingController editingController = TextEditingController();

//  String valuebus = "";

  @override
  void initState() {
    cargarInOrdenes();
    super.initState();
  }

  cargarInOrdenes() async {
    //ordenesProvider.getOrdenes(widget.token);
    ordenesProvider.cargarOrdenes(widget.token).then((value) {
      setState(() {
        listaOrdenToda = value;
        listaOrdenTodaFiltrada.addAll(listaOrdenToda);
      });
    });
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // print(widget.token); receive data works
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white)),
          backgroundColor: _appBarColor,
          title: Text('Mis órdenes de hoy'),
          centerTitle: false,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _panelContador(),
                _panelFiltros(context),
                _panelCabecera(),
                Expanded(child: _panelLista(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _panelFiltros(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
      child: Container(
        width: double.infinity,
        child: creandoFiltros(context),
      ),
    );
  }

  Widget _panelContador() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 2.0), //(x,y)
              blurRadius: 2.0,
              spreadRadius: 1),
        ],
      ),
      width: double.infinity,
      child: Text(
        'Órdenes de trabajo (${listaOrdenTodaFiltrada.length})',
        style: TextStyle(fontFamily: 'fuente72', fontSize: 18),
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }

  Widget _panelCabecera() {
    return Container(
      width: double.infinity,
      color: Color(0xffF2F2F2),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            'Descripción',
          )),
          Text(
            'Estatus',
          ),
        ],
      ),
    );
  }

  Widget _panelLista(BuildContext context) {
    return FutureBuilder(
        future: ordenesProvider.cargarOrdenes(widget.token),
        builder:
            (BuildContext context, AsyncSnapshot<List<OrdenModel>> snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: refrescarLista,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listaOrdenTodaFiltrada.length,
                itemBuilder: (context, i) {
                  return itemOt(listaOrdenTodaFiltrada[i]);
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget itemOt(OrdenModel orden) {
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: ListTile(
        onTap: () async {
          toast("Cargando Orden", Colors.black, Colors.grey[200]);
          cantOpyMat = await ordenesProvider.cantidadOpyMats(
              orden.numeroOt, widget.token);

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetallesOtPage(
              nrot: orden.numeroOt.toString(),
              descriot: orden.descripcion,
              token: widget.token,
              estado: orden.estado,
              cantOp: cantOpyMat[0],
              cantMat: cantOpyMat[1],
            );
          }));
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 9,
            ),
            Text(
              '${orden.numeroOt}',
              style: _estiloItemNro,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${orden.descripcion}',
              style: _estiloItemDescr,
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                RichText(
                  text: TextSpan(style: _oTextStyle, children: [
                    TextSpan(
                        text: 'Tipo Orden: ',
                        style: TextStyle(color: _greyColor)),
                    TextSpan(text: '${orden.tipoOt ?? ""}'),
                  ]),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                RichText(
                  text: TextSpan(style: _oTextStyle, children: [
                    TextSpan(
                        text: 'Prioridad: ',
                        style: TextStyle(color: _greyColor)),
                    TextSpan(text: '${orden.prioridad ?? ""}'),
                  ]),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
        trailing: Container(
          width: 130.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${orden.estado ?? ""}',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Hexcolor('${orden.estadoColor}')),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> refrescarLista() async {
    setState(() {
      ordenesProvider.cargarOrdenes(widget.token);
    });
  }

  void filterSearchResults(String query) {
    List<OrdenModel> dummySearchList = List<OrdenModel>();
    dummySearchList.addAll(listaOrdenToda);
    if (query.isNotEmpty) {
      List<OrdenModel> dummyListData = List<OrdenModel>();
      dummySearchList.forEach((item) {
        if (item.numeroOt.toLowerCase().contains(query) ||
            item.descripcion.toLowerCase().contains(query) ||
            item.tipoOt.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        listaOrdenTodaFiltrada.clear();
        listaOrdenTodaFiltrada.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        listaOrdenTodaFiltrada.clear();
        listaOrdenTodaFiltrada.addAll(listaOrdenToda);
      });
    }
  }

  Widget creandoFiltros(BuildContext context) {
    // print(_inputFieldDateController.text);
    //2020-07-24 00:00:00.000
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            color: Colors.white,
            width: 200.0,
            height: 40,
            child: TextField(
              controller: editingController,
              onChanged: (value) {
                filterSearchResults(value);
              },
              style: TextStyle(
                fontFamily: 'fuente72',
                fontSize: 14,
              ),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 7),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                hintText: 'Buscar',
                suffixIcon: editingController.text == ""
                    ? Icon(
                        Icons.search,
                        color: Color(0xff0854a0),
                      )
                    : IconButton(
                        onPressed: () {
                          editingController.clear();
                          setState(() {
                            filterSearchResults("");
                          });
                        },
                        icon: Icon(
                          Icons.clear,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void toast(String msg, Color colorTexto, Color colorbg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorbg,
        textColor: colorTexto,
        fontSize: 14.0);
  }
}
