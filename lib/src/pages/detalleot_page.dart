import 'package:flutter/material.dart';
import 'package:pmdigital_app/src/models/OrdenFullModel.dart';
import 'package:pmdigital_app/src/provider/ordenes_provider.dart';

class DetallesOtPage extends StatefulWidget {
  String nrot;
  String descriot;
  String token;
  DetallesOtPage({this.nrot, this.descriot, this.token});
  @override
  _DetallesOtPageState createState() => _DetallesOtPageState();
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

// ...

List<Item> _data = generateItems(1);

class _DetallesOtPageState extends State<DetallesOtPage> {
  Color _appBarColor = Color(0xff354A5F);
  TextStyle _styleAppBarTitle = TextStyle(
      fontFamily: 'fuente72', fontSize: 14.0, fontWeight: FontWeight.w400);

  TextStyle _styleLabelTab =
      TextStyle(fontFamily: 'fuente72', fontSize: 14, color: Color(0xff0854A0));

  bool opRealizada = false;
  OrdenesProvider ordenesProvider = new OrdenesProvider();
  OrdenFullModel resp;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   //resp = detallesOt();
  //   ordenesProvider.obtenerOrden(widget.nrot, widget.token).then((value) {
  //     setState(() {
  //       resp = value;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        title: Text('Orden ${widget.nrot}'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 60.0),
            width: double.infinity,
            height: double.infinity,
            child: ListView(
              children: [
                panelCabecera(),
              ],
            ),
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

  Widget panelCabecera() {
    var panelExpansibleDetalle = ExpansionPanelList(
      animationDuration: Duration(milliseconds: 300),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                title: Text(
                  '${widget.descriot}',
                  style: TextStyle(fontSize: 20, fontFamily: 'fuente72'),
                ),
              ),
            );
          },
          body: contenidoPanelExpansible(),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );

    return Container(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          panelExpansibleDetalle,
          panelTabs(),
          cuerpoPage(),
          cabecera(),
          // estos dos containers tendra que cambiarse por un listviewbuilder esto es temporal
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'operacion');
            },
            child: Container(
              height: 103.0,
              width: double.infinity,
              child: listaOperaciones(),
            ),
          ),
          Divider(),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'operacion');
            },
            child: Container(
              height: 103.0,
              width: double.infinity,
              child: listaOperaciones(),
            ),
          ),
          tituloMateriales(),
          cuerpoPage1(),
          cabecera(),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'operacion');
            },
            child: Container(
              height: 103.0,
              width: double.infinity,
              child: listaOperaciones(),
            ),
          ),
          Divider(),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'operacion');
            },
            child: Container(
              height: 103.0,
              width: double.infinity,
              child: listaOperaciones(),
            ),
          ),
          // listaOperaciones(),
        ],
      ),
    );
    // return Container(
    //   child: Column(
    //     // mainAxisSize: MainAxisSize.min,
    //     children: [
    //       ExpansionPanelList(
    //         animationDuration: Duration(milliseconds: 300),
    //         expansionCallback: (int index, bool isExpanded) {
    //           setState(() {
    //             _data[index].isExpanded = !isExpanded;
    //           });
    //         },
    //         children: _data.map<ExpansionPanel>((Item item) {
    //           return ExpansionPanel(
    //             headerBuilder: (BuildContext context, bool isExpanded) {
    //               return Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: ListTile(
    //                   title: Text(
    //                     '2W Ins Mech Blower Air System',
    //                     style: TextStyle(fontSize: 20, fontFamily: 'fuente72'),
    //                   ),
    //                 ),
    //               );
    //             },
    //             body: contenidoPanelExpansible(),
    //             isExpanded: item.isExpanded,
    //           );
    //         }).toList(),
    //       ),
    //       panelTabs(),
    //       cuerpoPage(),
    //       cabecera(),
    //       Container(
    //         height: 105.0,
    //         width: double.infinity,
    //         child: listaOperaciones(),
    //       ),
    //       Divider(),
    //       Container(
    //         height: 105.0,
    //         width: double.infinity,
    //         child: listaOperaciones(),
    //       ),
    //       Divider()
    //       // listaOperaciones(),
    //     ],
    //   ),
    // );
  }

  Widget contenidoPanelExpansible() {
    return FutureBuilder(
        future: ordenesProvider.obtenerOrden(widget.nrot, widget.token),
        builder:
            (BuildContext context, AsyncSnapshot<OrdenFullModel> snapshot) {
          if (snapshot.hasData) {
            resp = snapshot.data;
            return algo(resp);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget algo(OrdenFullModel resp) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${resp.estado}'),
          Text('Detalles de la orden'),
          SizedBox(
            height: 15,
          ),
          Text('Main Work Ctr.: ${resp.mainWork}'),
          SizedBox(
            height: 7,
          ),
          Text('Tipo de orden: ${resp.tipoOt}'),
          SizedBox(
            height: 7,
          ),
          Text('Tipo actividad: ${resp.tipoActividad}'),
          SizedBox(
            height: 15,
          ),
          Text('Programacion'),
          SizedBox(
            height: 15,
          ),
          Text('Inicio: ${resp.fechaFechaIniPlan}'),
          SizedBox(
            height: 7,
          ),
          Text('Fin: ${resp.fechaFinPlan}'),
          SizedBox(
            height: 7,
          ),
          Text('Prioridad: ${resp.prioridad}'),
          SizedBox(
            height: 7,
          ),
          Text('Revision: ${resp.revision}'),
          SizedBox(
            height: 15,
          ),
          Text('Equipo de Referencia'),
          SizedBox(
            height: 15,
          ),
          Text('Ubic. func: ${resp.ubiFuncional}'),
          SizedBox(
            height: 7,
          ),
          Text('Descripcion: Blower Air System 2 Cleaner Cells'),
          SizedBox(
            height: 7,
          ),
          Text('Sort field: ${resp.sortField}'),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget panelTabs() {
    return Container(
      height: 45,
      child: DefaultTabController(
          length: 2,
          child: TabBar(
              labelColor: Color(0xff0854A0),
              labelStyle: _styleLabelTab,
              tabs: [
                Tab(
                  text: 'OPERACIONES',
                ),
                Tab(
                  text: 'MATERIALES',
                ),
              ])),
//             child: DefaultTabController(
//                 length: 3,
//                 child: new Scaffold(
//                   appBar: AppBar(
//                     title: Text('Tabs Example'),
//                     bottom: TabBar(tabs: [
//                       Tab(
//                         icon: Icon(Icons.school),
//                       ),
//                       Tab(
//                         icon: Icon(Icons.home),
//                       ),
//                       Tab(
//                         icon: Icon(Icons.local_hospital),
//                       ),
//                     ]),
//                   ),
//                   body: TabBarView(children: [
// //             any widget can work very well here <3

//                     new Container(
//                       color: Colors.redAccent,
//                       child: Center(
//                         child: Text(
//                           'Hi from School',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     new Container(
//                       color: Colors.greenAccent,
//                       child: Center(
//                         child: Text(
//                           'Hi from home',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     new Container(
//                       color: Colors.blueAccent,
//                       child: Center(
//                         child: Text(
//                           'Hi from Hospital',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ]),
//                 )),
    );
  }

  Widget cuerpoPage() {
    Widget panelContador = Container(
      height: 60,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text('Operaciones(2)'),
      ),
    );
    return Column(
      children: [
        panelContador,
      ],
    );
  }

  Widget cabecera() {
    return Container(
      color: Color(0xffF2F2F2),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 50.0,
      child: Row(
        children: [
          Expanded(child: Text('Descripcion')),
          Text('Estatus'),
        ],
      ),
    );
  }

  Widget listaOperaciones() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text('Inspect Blower Air System'),
            ],
          ),
          trailing: Container(
            width: 72,
            height: 25,
            child: Row(
              children: [
                Checkbox(
                  value: opRealizada,
                  onChanged: (bool value) {
                    setState(() {
                      opRealizada = value;
                    });
                  },
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text('Operación: 0010'),
              SizedBox(height: 10.0),
              Text('Trabajo: 4 HH'),
            ],
          ),
        )
      ],
    );
  }

  Widget tituloMateriales() {
    return Container(
      padding: EdgeInsets.all(20.0),
      color: Color(0xffF2F2F2),
      width: double.infinity,
      height: 60.0,
      child: Text('MATERIALES'),
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
              FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                  onPressed: () {},
                  child: Text(
                    'Guardar',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'fuente72',
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Iniciar',
                    style: TextStyle(fontSize: 15, fontFamily: 'fuente72'),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget cuerpoPage1() {
    Widget panelContador = Container(
      height: 60,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text('Lineas de Materiales(2)'),
      ),
    );
    return Column(
      children: [
        panelContador,
      ],
    );
  }
}
