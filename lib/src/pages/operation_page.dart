import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pmdigital_app/src/models/OperacionFullModel.dart';
import 'package:pmdigital_app/src/models/OrdenFullModel.dart';
import 'package:pmdigital_app/src/pages/foto_page.dart';
import 'package:pmdigital_app/src/pages/nota_page.dart';
import 'package:pmdigital_app/src/provider/operacion_provider.dart';
import 'package:pmdigital_app/src/widgets/tituloSeccion_widget.dart';

import 'image_network.dart';

class OperacionPage extends StatefulWidget {
  String token;
  String idop;
  String descriop;
  OperacionPage({this.token, this.idop, this.descriop});
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
  var formater = new DateFormat('MMM d, yyyy • hh:mm');
  Color _appBarColor = Color(0xff354A5F);
  TextStyle _styleTitleExpansibleBar = TextStyle(
      fontFamily: 'fuente72', fontSize: 14.0, fontWeight: FontWeight.w700);

  TextStyle _styleAppBarTitle = TextStyle(
      fontFamily: 'fuente72', fontSize: 14.0, fontWeight: FontWeight.w400);

  TextStyle _styleLabelTab =
      TextStyle(fontFamily: 'fuente72', fontSize: 13, color: Color(0xff0854A0));

  TextStyle _oTextStyle =
      TextStyle(fontFamily: 'fuente72', fontSize: 14.0, color: Colors.black);

  TextStyle styleContador = TextStyle(fontFamily: 'fuente72', fontSize: 18.0);

  Color _greyColor = Color(0xff6A6D70);

  final OperacionMaterialProvider operacionMaterialProvider =
      new OperacionMaterialProvider();

  File foto;

  bool loading;

  List<String> ids;

  var provFotos;
  var provNotas;
  var provMats;
  var provServ;

  List<Nota> listaNotas = new List<Nota>();
  List<Foto> listaFotos = new List<Foto>();

  @override
  void initState() {
    iniciarProviders();
    cargarNotas();
    cargarFotos();
    super.initState();
  }

  cargarNotas() async {
    await operacionMaterialProvider
        .obtenerNotasOperacion(widget.idop, widget.token)
        .then((value) {
      setState(() {
        listaNotas = value;
      });
    });
  }

  cargarFotos() async {
    await operacionMaterialProvider
        .obtenerFotosOperacion(widget.idop, widget.token)
        .then((value) {
      setState(() {
        listaFotos = value;
      });
    });
  }

  iniciarProviders() async {
    setState(() {
      provFotos = operacionMaterialProvider.obtenerFotosOperacion(
          widget.idop, widget.token);
      provNotas = operacionMaterialProvider.obtenerNotasOperacion(
          widget.idop, widget.token);
      provMats = operacionMaterialProvider.obtenerMaterialesOperacion(
          widget.idop, widget.token);
      provServ = operacionMaterialProvider.obtenerServiciosOperacion(
          widget.idop, widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: _appBarColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            Text(
              'Operacion',
              style: TextStyle(fontSize: 14.0),
            )
            // Your widgets here
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.sync),
              onPressed: () {
                toast('Actualizando. Un momento porfavor..');
                setState(() {
                  provFotos = operacionMaterialProvider.obtenerFotosOperacion(
                      widget.idop, widget.token);
                  provNotas = operacionMaterialProvider.obtenerNotasOperacion(
                      widget.idop, widget.token);
                });
              })
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 60.0),
            width: double.infinity,
            height: double.infinity,
            child: ListView(
              children: [
                panelCabecera(context),
                fotosPanel(context),
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

  Widget panelCabecera(BuildContext context) {
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
                  '${widget.descriop}',
                  style: TextStyle(fontSize: 20, fontFamily: 'fuente72'),
                ),
              ),
            );
          },
          body: panelExpansibleFuture(),
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
          serviciosPanel(),
          materialesPanel(),
          notasPanel(),
          // listaOperaciones(),
        ],
      ),
    );
  }

  Widget panelTabs() {
    return Container(
      height: 45,
      child: DefaultTabController(
          length: 4,
          child: TabBar(
              isScrollable: true,
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

  Widget serviciosPanel() {
    Widget panelContador = FutureBuilder(
        future: provServ,
        builder: (context, AsyncSnapshot<List<Servicio>> snapshot) {
          if (snapshot.hasData) {
            return Container(
                height: 40.0,
                padding: EdgeInsets.only(left: 20.0),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  'Servicios (${snapshot.data.length})',
                  style: styleContador,
                ));
          } else {
            return Container(
                height: 40.0,
                padding: EdgeInsets.only(left: 20.0),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  'Servicios (Estimando..)',
                  style: styleContador,
                ));
          }
        });

    return Column(
      children: [
        panelContador,
        futureServicios(),
      ],
    );
  }

  Widget panelExpansibleFuture() {
    return FutureBuilder(
      future:
          operacionMaterialProvider.obtenerOperacion(widget.idop, widget.token),
      builder: (context, AsyncSnapshot<OperacionFullModel> snapshot) {
        if (snapshot.hasData) {
          return contenidoPanelExpansible(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
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
                  onPressed: () {
                    cambiarEstadoOp("Confirmar");
                  },
                  child: Text(
                    'Confirmar',
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

  void cambiarEstadoOp(String value) async {
    var num;
    if (value == "Confirmar") {
      num = 1;
      var resp = await operacionMaterialProvider.cambiarEstadoOpe(
          widget.idop, widget.token, num.toString());
      print(resp);
      if (resp['code'] == 200) {
        toast('La operacion ha sido confirmada');
      } else {
        toast('Ha surgido un inconveniente.');
      }
    }
    if (value == "No Confirmar") {
      num = 0;
      var resp = await operacionMaterialProvider.cambiarEstadoOpe(
          widget.idop, widget.token, num.toString());
      print(resp);
      if (resp['code'] == 200) {
        toast('La operacion no ha sido confirmada');
      } else {
        toast('Ha surgido un inconveniente.');
      }
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

  Widget materialesPanel() {
    Widget panelContador = FutureBuilder(
        future: provMats,
        builder: (context, AsyncSnapshot<List<Materiale>> snapshot) {
          if (snapshot.hasData) {
            return Container(
                height: 40.0,
                padding: EdgeInsets.only(left: 20.0),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  'Linea de Materiales (${snapshot.data.length})',
                  style: styleContador,
                ));
          } else {
            return Container(
                height: 40.0,
                padding: EdgeInsets.only(left: 20.0),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  'Linea de Materiales (Estimando..)',
                  style: styleContador,
                ));
          }
        });

    Widget cabecera = Container(
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
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TituloSeccionWidget(value: 'MATERIALES'),
          panelContador,
          cabecera,
          futureBuilderMateriales(),
        ],
      ),
    );
  }

  Widget notasPanel() {
    Widget panelContador = FutureBuilder(
        future: provNotas,
        builder: (context, AsyncSnapshot<List<Nota>> snapshot) {
          if (snapshot.hasData) {
            return Container(
                height: 40.0,
                padding: EdgeInsets.only(left: 20.0),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  'Notas (${listaNotas.length})',
                  style: styleContador,
                ));
          } else {
            return Container(
                height: 40.0,
                padding: EdgeInsets.only(left: 20.0),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  'Notas (Estimando..)',
                  style: styleContador,
                ));
          }
        });

    Widget cabecera = Container(
      color: Color(0xffF2F2F2),
      padding: EdgeInsets.only(right: 20.0),
      height: 50.0,
      child: Row(
        children: [Expanded(child: panelContador), popNota()],
      ),
    );
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TituloSeccionWidget(value: 'NOTAS'),
          cabecera,
          futureBuilderNotas(),
          // Text('Jul 28, 2020 * 7:58 PM'),
        ],
      ),
    );
  }

  Widget fotosPanel(BuildContext context) {
    Widget panelContador = FutureBuilder(
        future: provFotos,
        builder: (context, AsyncSnapshot<List<Foto>> snapshot) {
          if (snapshot.hasData) {
            return Container(
                height: 40.0,
                padding: EdgeInsets.only(left: 20.0),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  'Fotos (${listaFotos.length})',
                  style: styleContador,
                ));
          } else {
            return Container(
                height: 40.0,
                padding: EdgeInsets.only(left: 20.0),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  'Fotos (Estimando..)',
                  style: styleContador,
                ));
          }
        });

    Widget cabecera = Container(
      color: Color(0xffF2F2F2),
      padding: EdgeInsets.only(right: 20.0),
      height: 50.0,
      child: Row(
        children: [Expanded(child: panelContador), popFoto()],
      ),
    );
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TituloSeccionWidget(value: 'FOTOS'),
          cabecera,
          futureBuilderFotos(),
        ],
      ),
    );
  }

  Widget contenidoPanelExpansible(OperacionFullModel data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${data.estadoOp}'),
          Text(
            'Detalles de la operación',
            style: _styleTitleExpansibleBar,
          ),
          SizedBox(
            height: 15,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Oper. Work Ctr.: ',
                  style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.operationWorkCenter ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Cond. Sist.: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: 'ver condicion sistema'),
            ]),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Programacion',
            style: _styleTitleExpansibleBar,
          ),
          SizedBox(
            height: 15,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Inicio: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.fechaIniPlan ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Fin: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.fechaFinPlan ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Duracion: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.duracionReal ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Personal: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.numberReal ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Trabajo: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.workReal ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Equipo de Referencia',
            style: _styleTitleExpansibleBar,
          ),
          SizedBox(
            height: 15,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Ubic. Func: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.ubiFuncional ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Descripcion: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.descripcionEquipo ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Sort Field: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.sortField ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget futureBuilderMateriales() {
    return FutureBuilder(
      future: provMats,
      builder: (context, AsyncSnapshot<List<Materiale>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('No existen Materiales en la Operacion'),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                height: 0.1,
                color: Colors.grey,
              ),
            ),
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return itemMat(snapshot.data[index]);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget itemMat(Materiale data) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: '${data.descripcion}'),
            ]),
          ),
        ],
      ),
      trailing: Container(
          alignment: Alignment.center,
          width: 50,
          height: 25,
          child: Text('${data.cantidad} EA')),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 6.0,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Material: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.numero}'),
            ]),
          ),
          SizedBox(height: 6.0),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Reserva: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.reserva}'),
            ]),
          ),
        ],
      ),
    );
  }

  Widget futureBuilderNotas() {
    return FutureBuilder(
      future: provNotas,
      builder: (context, AsyncSnapshot<List<Nota>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('No existen Notas en la Operacion'),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                height: 0.1,
                color: Colors.grey,
              ),
            ),
            physics: NeverScrollableScrollPhysics(),
            itemCount: listaNotas.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return itemNota(listaNotas[index]);
            },
          );
        } else {
          return Container(
            height: 10.0,
          );
        }
      },
    );
  }

  Widget itemNota(Nota data) {
    return ListTile(
      title: RichText(
        text: TextSpan(style: _oTextStyle, children: [
          TextSpan(
              text: '${data.nombre} ${data.apellido} : ',
              style: TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(text: '${data.descripcion}'),
        ]),
      ),
      subtitle: Text(
        formater.format(DateTime.parse('${data.fecha}')),
        style: TextStyle(fontSize: 12.0, fontFamily: 'fuente72'),
      ),
      trailing: popEditDelNota(data.id.toString(), data.descripcion.toString()),
    );
  }

  Widget futureServicios() {
    return FutureBuilder(
      future: provServ,
      builder: (context, AsyncSnapshot<List<Servicio>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('No existen Servicios en la Operacion'),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                height: 0.1,
                color: Colors.grey,
              ),
            ),
            itemCount: snapshot.data.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return itemServicio(snapshot.data[index]);
            },
          );
        } else {
          return Container(
            height: 10.0,
          );
        }
      },
    );
  }

  Widget itemServicio(Servicio data) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          data.descripcion,
          style: _oTextStyle,
        ),
      ),
    );
  }

  Widget popNota() {
    return PopupMenuButton<String>(
      child: Icon(Icons.add),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "añadir_nota",
          child: Text(
            "Añadir Nota",
            style: TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
          ),
        )
      ],
      onSelected: (value) {
        opcionesNota(value);
      },
    );
  }

  void opcionesNota(String value) {
    if (value == "añadir_nota") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NotaPage(
          token: widget.token,
          idop: widget.idop,
        );
      })).then((value) {
        cargarNotas();
      });
    }
  }

  Widget popEditDelNota(String idnota, String contnota) {
    return PopupMenuButton<String>(
      child: Icon(Icons.more_horiz),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "editar",
          child: Text(
            "Editar nota",
            style: TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
          ),
        ),
        PopupMenuItem<String>(
          value: "eliminar",
          child: Text(
            "Eliminar nota",
            style: TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
          ),
        )
      ],
      onSelected: (value) {
        editDelNota(value, idnota, contnota);
      },
    );
  }

  void editDelNota(String value, String idnota, String contnota) async {
    toast('Espere un momento porfavor ..');
    if (value == "eliminar") {
      var resp =
          await operacionMaterialProvider.eliminarNota(widget.token, idnota);
      if (resp['code'] == 200) {
        toast('La nota ha sido eliminada exitosamente');
        setState(() {
          cargarNotas();
        });
      } else {
        toast('Ha ocurrido un error inesperado borrando la nota');
      }
    }
    if (value == "editar") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NotaPage(
          token: widget.token,
          idop: idnota,
          contnota: contnota,
          tipo: value,
        );
      }));
    }
  }

  Widget popFoto() {
    return PopupMenuButton<String>(
      child: Icon(Icons.add),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "tomar_foto",
          child: Text(
            "Tomar fotografia",
            style: TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
          ),
        ),
        PopupMenuItem<String>(
          value: "escoger_foto",
          child: Text(
            "Escoger Fotografia",
            style: TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
          ),
        )
      ],
      onSelected: (value) {
        opcionesFoto(value);
      },
    );
  }

  void opcionesFoto(String value) {
    if (value == "tomar_foto") {
      tomarFoto();
    }
    if (value == "escoger_foto") {
      seleccionarFoto();
    }
  }

  void seleccionarFoto() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 78,
      maxHeight: 768,
      maxWidth: 1024,
    );
    try {
      foto = File(pickedFile.path);
    } catch (e) {
      print('$e');
    }
    if (foto != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ImagePage(foto, widget.token, widget.idop);
          },
        ),
      ).then((value) => cargarFotos());
    } else {
      print('ruta de imagen nula');
    }
  }

  tomarFoto() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      imageQuality: 78,
      maxHeight: 768,
      maxWidth: 1024,
    );
    try {
      foto = File(pickedFile.path);
    } catch (e) {
      print('$e');
    }

    if (foto != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ImagePage(foto, widget.token, widget.idop);
          },
        ),
      ).then((value) => cargarFotos());
    } else {
      print('ruta de imagen nula');
    }
  }

  Widget futureBuilderFotos() {
    return Container(
      height: 150.0,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: FutureBuilder(
        future: provFotos,
        builder: (context, AsyncSnapshot<List<Foto>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(
                child: Text('No existen Fotografias en la Operacion'),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: listaFotos.length,
              itemBuilder: (context, index) {
                return itemFoto(listaFotos[index]);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget itemFoto(Foto data) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7.0),
          child: Image.network(
            data.url,
            fit: BoxFit.fill,
            width: 100.0,
            height: 50.0,
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ImagePageNetwork(
                  '${data.url}', '${widget.token}', '${data.id.toString()}');
            },
          ),
        ).then((value) => cargarFotos());
      },
    );
  }
}
