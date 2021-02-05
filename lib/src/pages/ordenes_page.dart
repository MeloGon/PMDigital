import 'package:flutter/material.dart';

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

  final busController = new TextEditingController(text: "");
  OrdenesProvider ordenesProvider = new OrdenesProvider();
  List<OrdenModel> listaOrdenToda = new List<OrdenModel>();
  List<OrdenModel> listaOrdenTodaFiltrada = new List<OrdenModel>();

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
        listaOrdenTodaFiltrada = listaOrdenToda;
      });
    });
  }

  Widget build(BuildContext context) {
    // print(widget.token); receive data works
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: _appBarColor,
        title: Text('Avances'),
        centerTitle: false,
        actions: <Widget>[
          //_perfilCircle(context),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.supervised_user_circle,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: "cerrar_sesion",
                child: Text(
                  "Cerrar Sesion",
                  style: TextStyle(fontFamily: 'fuente72'),
                ),
              ),
            ],
            onSelected: (value) {
              //     if (value == "tomar_foto") {
              // print('Nothing');
              if (value == "cerrar_sesion") {}
            },
          )
        ],
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
              _panelFiltros(context),
              _panelContador(),
              _panelCabecera(),
              Expanded(child: _panelLista(context)),
            ],
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
      width: double.infinity,
      child: Text(
        'Órdenes de trabajo',
        style: TextStyle(fontFamily: 'fuente72', fontSize: 18),
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }

  Widget _panelCabecera() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            'No. Orden',
          )),
          Text(
            'Cumplimiento',
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
            final ordenes = snapshot.data;
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
        onTap: () async {},
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 9,
            ),
            Text(
              '${orden.numeroOt}',
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${orden.descripcion}',
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
                Text(
                  'Criticidad: ',
                  style: TextStyle(fontFamily: 'fuente72'),
                ),
                Text(
                  '${orden.prioridad}',
                  style: TextStyle(
                    fontFamily: 'fuente72',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Text('Área: ', style: TextStyle(fontFamily: 'fuente72')),
                Text('${orden.tipoOt}'),
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
      ),
    );
  }

  Future<Null> refrescarLista() async {
    setState(() {
      ordenesProvider.cargarOrdenes(widget.token);
    });
  }

  Widget creandoFiltros(BuildContext context) {
    // print(_inputFieldDateController.text);
    //2020-07-24 00:00:00.000
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                listaOrdenTodaFiltrada = listaOrdenToda
                    .where((u) => (u.numeroOt
                            .toLowerCase()
                            .contains(value.toLowerCase()) ||
                        u.descripcion
                            .toLowerCase()
                            .contains(value.toLowerCase()) ||
                        u.tipoOt.toLowerCase().contains(value.toLowerCase()) ||
                        u.prioridad
                            .toLowerCase()
                            .contains(value.toLowerCase()) ||
                        u.prioridad
                            .toLowerCase()
                            .contains(value.toLowerCase())))
                    .toList();
              });
            },
            style: TextStyle(
              fontFamily: 'fuente72',
              fontSize: 14,
            ),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                hintText: 'Buscar',
                suffixIcon: Icon(
                  Icons.search,
                  color: Color(0xff0854a0),
                )),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
