import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pmdigital_app/src/models/OperacionFullModel.dart';
import 'package:pmdigital_app/src/models/OrdenFullModel.dart';
import 'package:pmdigital_app/src/pages/foto_page.dart';
import 'package:pmdigital_app/src/pages/nota_page.dart';
import 'package:pmdigital_app/src/provider/operacion_provider.dart';

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
  Color _appBarColor = Color(0xff354A5F);
  TextStyle _styleTitleExpansibleBar = TextStyle(
      fontFamily: 'fuente72', fontSize: 14.0, fontWeight: FontWeight.w700);

  TextStyle _styleAppBarTitle = TextStyle(
      fontFamily: 'fuente72', fontSize: 14.0, fontWeight: FontWeight.w400);

  TextStyle _styleLabelTab =
      TextStyle(fontFamily: 'fuente72', fontSize: 13, color: Color(0xff0854A0));

  TextStyle _oTextStyle =
      TextStyle(fontFamily: 'fuente72', fontSize: 14.0, color: Colors.black);

  Color _greyColor = Color(0xff6A6D70);

  final OperacionMaterialProvider operacionMaterialProvider =
      new OperacionMaterialProvider();

  File foto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: _appBarColor,
        title: Text(
          'Operación 0020',
          style: _styleAppBarTitle,
        ),
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
          fotosPanel(),
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
    Widget panelContador = Container(
      height: 60,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text('Servicios(1)'),
      ),
    );

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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'MATERIALES',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text('Linea de Materiales(1)'),
          ),
          cabecera,
          futureBuilderMateriales(),
        ],
      ),
    );
  }

  Widget notasPanel() {
    Widget cabecera = Container(
      color: Color(0xffF2F2F2),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 50.0,
      child: Row(
        children: [Expanded(child: Text('Notas(1)')), popNota()],
      ),
    );
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'NOTAS',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          cabecera,
          futureBuilderNotas(),
          // Text('Jul 28, 2020 * 7:58 PM'),
        ],
      ),
    );
  }

  Widget fotosPanel() {
    Widget cabecera = Container(
      color: Color(0xffF2F2F2),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 50.0,
      child: Row(
        children: [Expanded(child: Text('Fotos(3)')), popFoto()],
      ),
    );
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'FOTOS',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          cabecera,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.red),
              ),
              Container(
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.cyan),
              ),
              Container(
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.blue),
              ),
            ],
          )
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
              TextSpan(text: '${data.operationWorkCenter}'),
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
              TextSpan(text: '${data.fechaIniPlan}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Fin: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.fechaFinPlan}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Duracion: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.duracionReal}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Personal: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.numberReal}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Trabajo: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.workReal}'),
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
              TextSpan(text: '${data.ubiFuncional}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Descripcion: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.descripcionEquipo}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Sort Field: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${data.sortField}'),
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
      future: operacionMaterialProvider.obtenerMaterialesOperacion(
          widget.idop, widget.token),
      builder: (context, AsyncSnapshot<List<Materiale>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('No existen Materiales en la Operacion'),
            );
          }
          return ListView.builder(
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
      future: operacionMaterialProvider.obtenerNotasOperacion(
          widget.idop, widget.token),
      builder: (context, AsyncSnapshot<List<Nota>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('No existen Notas en la Operacion'),
            );
          }
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return itemNota(snapshot.data[index]);
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

  Widget itemNota(Nota data) {
    return ListTile(
      title: RichText(
        text: TextSpan(style: _oTextStyle, children: [
          TextSpan(
              text: '${data.nombre} ${data.apellido} : ',
              style: TextStyle(color: _greyColor)),
          TextSpan(text: '${data.descripcion}'),
        ]),
      ),
      subtitle: Text('${data.fecha}'),
      trailing: popEditDelNota(data.id.toString(), data.descripcion.toString()),
    );
  }

  Widget futureServicios() {
    return FutureBuilder(
      future: operacionMaterialProvider.obtenerServiciosOperacion(
          widget.idop, widget.token),
      builder: (context, AsyncSnapshot<List<Servicio>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('No existen Servicios en la Operacion'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return itemServicio(snapshot.data[index]);
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

  Widget itemServicio(Servicio data) {
    return ListTile(
      title: Text(
        data.descripcion,
        style: _oTextStyle,
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
      }));
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
    if (value == "eliminar") {
      var resp =
          await operacionMaterialProvider.eliminarNota(widget.token, idnota);
      if (resp['code'] == 200) {
        toast('La nota ha sido eliminada exitosamente');
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
      // imageQuality: 78,
      // maxHeight: 768,
      // maxWidth: 1024,
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
            // return ImagePage(foto, widget.token, widget.idot);
          },
        ),
      );
    } else {
      print('ruta de imagen nula');
    }
  }

  void tomarFoto() {}
}
