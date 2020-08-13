import 'package:flutter/material.dart';

class OperacionPage extends StatefulWidget {
  @override
  _OperacionPageState createState() => _OperacionPageState();
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

class _OperacionPageState extends State<OperacionPage> {
  Color _appBarColor = Color(0xff354A5F);
  TextStyle _styleAppBarTitle = TextStyle(
      fontFamily: 'fuente72', fontSize: 14.0, fontWeight: FontWeight.w400);

  TextStyle _styleLabelTab =
      TextStyle(fontFamily: 'fuente72', fontSize: 14, color: Color(0xff0854A0));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        title: Text('Orden 100711361'),
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
                  '2W Ins Mech Blower Air System',
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
          // estos dos containers tendra que cambiarse por un listviewbuilder esto es temporal
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

  Widget panelTabs() {
    return Container(
      height: 50,
      child: DefaultTabController(
          length: 4,
          child: TabBar(
              labelColor: Color(0xff0854A0),
              labelStyle: _styleLabelTab,
              tabs: [
                Tab(
                  text: 'SERVICIOS',
                ),
                Tab(
                  text: 'MATERIALES',
                ),
                Tab(
                  text: 'NOTAS',
                ),
                Tab(
                  text: 'FOTOS',
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

  Widget contenidoPanelExpansible() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('No Confirmada'),
          Text('Detalles de la operación'),
          SizedBox(
            height: 15,
          ),
          Text('Oper. Work Ctr.: MFLO-MEC'),
          SizedBox(
            height: 7,
          ),
          Text('Cond. Sist.: 3 - Offline - PU'),
          SizedBox(
            height: 15,
          ),
          Text('Programacion'),
          SizedBox(
            height: 15,
          ),
          Text('Inicio: Jul 27, 2020'),
          SizedBox(
            height: 7,
          ),
          Text('Fin: Jul 27, 2020'),
          SizedBox(
            height: 7,
          ),
          Text('Duracion: 3 HR'),
          SizedBox(
            height: 7,
          ),
          Text('Personal: 2'),
          SizedBox(
            height: 7,
          ),
          Text('Trabajo: 6 HH'),
          SizedBox(
            height: 15,
          ),
          Text('Equipo de Referencia'),
          SizedBox(
            height: 15,
          ),
          Text('Ubic. func: PE01-20-20-50-FLBW001.BW02'),
          SizedBox(
            height: 7,
          ),
          Text('Descripcion: Blower Air System 2 Cleaner Cells'),
          SizedBox(
            height: 7,
          ),
          Text('Sort field: 0330-CPB-0002'),
          SizedBox(
            height: 15,
          ),
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
                    'Confirmar',
                    style: TextStyle(fontSize: 15, fontFamily: 'fuente72'),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
