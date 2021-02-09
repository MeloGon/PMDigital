import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pmdigital_app/src/models/OrdenFullModel.dart';
import 'package:pmdigital_app/src/pages/operation_page.dart';
import 'package:pmdigital_app/src/provider/operacion_provider.dart';
import 'package:pmdigital_app/src/provider/ordenes_provider.dart';
import 'package:pmdigital_app/src/widgets/tituloSeccion_widget.dart';

class DetallesOtPage extends StatefulWidget {
  String nrot;
  String descriot;
  String token;
  String estado;
  String cantOp;
  String cantMat;
  DetallesOtPage(
      {this.nrot,
      this.descriot,
      this.token,
      this.estado,
      this.cantOp,
      this.cantMat});
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

  TextStyle _styleTitleExpansibleBar =
      TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700);

  TextStyle _styleLabelTab =
      TextStyle(fontFamily: 'fuente72', fontSize: 14, color: Color(0xff0854A0));

  TextStyle _oTextStyle =
      TextStyle(fontFamily: 'fuente72', fontSize: 14.0, color: Colors.black);

  TextStyle _titleOpStyle = TextStyle(
      fontSize: 14.0, color: Color(0xff32363A), fontWeight: FontWeight.w700);

  OrdenesProvider ordenesProvider = new OrdenesProvider();
  OperacionMaterialProvider operacionMaterialProvider =
      new OperacionMaterialProvider();
  OrdenFullModel resp;
  Color _greyColor = Color(0xff6A6D70);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        centerTitle: false,
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            Text(
              'Orden ${widget.nrot}',
              style: TextStyle(fontSize: 14.0),
            )
            // Your widgets here
          ],
        ),
        // title: Text(
        //   'Orden ${widget.nrot}',
        //   style: TextStyle(fontSize: 14.0),
        // ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 60.0),
            width: double.infinity,
            height: double.infinity,
            child: ListView(
              children: [
                cuerpoWid(context),
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
                child: _options(context, widget.estado),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget cuerpoWid(BuildContext context) {
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

    return SingleChildScrollView(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          panelExpansibleDetalle,
          panelTabs(),
          cabecera(),
          listaOperaciones(context),
          TituloSeccionWidget(
            value: 'MATERIALES',
          ),
          cabecera(),
          listaMateriales(context),
        ],
      ),
    );
  }

  //ver lo de actualizar el boton y el estado
  Widget contenidoPanelExpansible() {
    return FutureBuilder(
        future: ordenesProvider.obtenerOrden(widget.nrot, widget.token),
        builder:
            (BuildContext context, AsyncSnapshot<OrdenFullModel> snapshot) {
          if (snapshot.hasData) {
            resp = snapshot.data;
            _options(context, snapshot.data.estado);
            // print(resp.materiales[0]);
            return contenidoDetalles(resp);
          } else {
            return Container(
                height: 100.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget contenidoDetalles(OrdenFullModel resp) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${resp.estado}'),
          Text('Detalles de la orden', style: _styleTitleExpansibleBar),
          SizedBox(
            height: 15,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Main Work Ctr: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${resp.mainWork ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Tipo de orden: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${resp.tipoOt ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Tipo actividad: ',
                  style: TextStyle(color: _greyColor)),
              TextSpan(text: '${resp.tipoActividad ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 15,
          ),
          Text('Programación', style: _styleTitleExpansibleBar),
          SizedBox(
            height: 15,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Inicio: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${resp.fechaFechaIniPlan ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Fin: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${resp.fechaFinPlan ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Prioridad: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${resp.prioridad ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Revision: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${resp.revision ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 15,
          ),
          Text('Equipo de Referencia', style: _styleTitleExpansibleBar),
          SizedBox(
            height: 15,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Ubic. func: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${resp.ubiFuncional ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Descripción: Blower Air System 2 Cleaner Cells ',
                  style: TextStyle(color: _greyColor)),
              TextSpan(text: '${resp.ubiFuncional ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 7,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Sort field: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${resp.sortField ?? ""}'),
            ]),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget panelTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 3), // shadow direction: bottom right
          )
        ],
      ),
      height: 45,
      child: DefaultTabController(
          length: 2,
          child: TabBar(
              labelColor: Color(0xff0854A0),
              labelStyle: _styleLabelTab,
              tabs: [
                Tab(
                  text: 'OPERACIONES (${widget.cantOp})',
                ),
                Tab(
                  text: 'MATERIALES (${widget.cantMat})',
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

  Widget cabecera() {
    return Container(
      color: Color(0xffF2F2F2),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 50.0,
      child: Row(
        children: [
          Expanded(
              child: Text(
            'Descripción',
            style: _oTextStyle,
          )),
          Text(
            'Estatus',
            style: _oTextStyle,
          ),
        ],
      ),
    );
  }

  Widget listaOperaciones(BuildContext context) {
    return FutureBuilder(
        future: operacionMaterialProvider.obtenerOperaciones(
            widget.nrot, widget.token),
        builder:
            (BuildContext context, AsyncSnapshot<List<Operacion>> snapshot) {
          if (snapshot.hasData) {
            final operaciones = snapshot.data;
            // print(operaciones[0].descripcion);return Center(child: Text('si hay operaciones'),);
            if (operaciones.length == 0) {
              return Container(
                height: 30.0,
                child: Center(
                    child: Text(
                  'No existen operaciones en la Orden',
                  style: TextStyle(
                      fontFamily: 'fuente72',
                      fontSize: 13.0,
                      color: Colors.grey),
                )),
              );
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Divider(
                  height: 0.1,
                  color: Colors.grey,
                ),
              ),
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: operaciones.length,
              itemBuilder: (context, i) {
                return itemOpe(operaciones[i]);
              },
            );
          } else {
            return Container(
                height: 100, child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget _options(BuildContext context, String estado) {
    String estadoBoton = "";
    print(estado);
    if (estado == "En proceso") {
      estadoBoton = "Finalizar";
    }
    if (estado == "Pendiente") {
      estadoBoton = "Iniciar";
    }
    if (estado == "Terminado") {
      estadoBoton = "Iniciar";
    }
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              PopupMenuButton<String>(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 20.0),
                      child: Text(
                        estadoBoton,
                        style: TextStyle(
                            fontFamily: 'fuente72',
                            fontSize: 14.0,
                            color: Color(0xff0854A1)),
                      ),
                    ),
                  ],
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "Iniciar",
                    child: Text(
                      "Iniciar",
                      style: TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "Reprogramar",
                    child: Text(
                      "Repogramar",
                      style: TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
                    ),
                  ),
                ],
                onSelected: (value) {
                  cambiarEstado(value);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget itemOpe(Operacion operacion) {
    bool opRealizada = false;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OperacionPage(
            token: widget.token,
            idop: operacion.id.toString(),
            descriop: operacion.descripcion,
          );
        }));
      },
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.0,
            ),
            RichText(
              text: TextSpan(style: _titleOpStyle, children: [
                TextSpan(text: '${operacion.descripcion}'),
              ]),
            ),
          ],
        ),
        trailing: Container(
          width: 72,
          height: 25,
          child: Row(
            children: [
              Checkbox(
                value: opRealizada,
                // onChanged: (bool value) {
                //   setState(() {
                //     opRealizada = value;
                //   });
                // },
                onChanged: null,
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 6.0,
            ),
            RichText(
              text: TextSpan(style: _oTextStyle, children: [
                TextSpan(
                    text: 'Operación: ', style: TextStyle(color: _greyColor)),
                TextSpan(text: '${operacion.actividad}'),
              ]),
            ),
            SizedBox(height: 6.0),
            RichText(
              text: TextSpan(style: _oTextStyle, children: [
                TextSpan(
                    text: 'Trabajo: ', style: TextStyle(color: _greyColor)),
                TextSpan(text: '${operacion.workPlan}'),
              ]),
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget listaMateriales(BuildContext context) {
    return FutureBuilder(
        future: operacionMaterialProvider.obtenerMateriales(
            widget.nrot, widget.token),
        builder:
            (BuildContext context, AsyncSnapshot<List<Materiale>> snapshot) {
          if (snapshot.hasData) {
            final materiales = snapshot.data;
            if (materiales.length == 0) {
              return Container(
                height: 30.0,
                child: Center(
                    child: Text(
                  'No existen materiales en la Orden',
                  style: TextStyle(
                      fontFamily: 'fuente72',
                      fontSize: 13.0,
                      color: Colors.grey),
                )),
              );
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Divider(
                  height: 0.1,
                  color: Colors.grey,
                ),
              ),
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: materiales.length,
              itemBuilder: (context, i) {
                return itemMate(materiales[i]);
              },
            );
          } else {
            return Container(
                height: 100, child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget itemMate(Materiale material) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15.0,
          ),
          RichText(
            text: TextSpan(style: _titleOpStyle, children: [
              TextSpan(text: '${material.descripcion}'),
            ]),
          ),
        ],
      ),
      trailing: Container(
          alignment: Alignment.center,
          width: 50,
          height: 25,
          child: Text('${material.cantidad} EA')),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 6.0,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Material: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${material.numero}'),
            ]),
          ),
          SizedBox(height: 6.0),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Reserva: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '${material.reserva}'),
            ]),
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  void cambiarEstado(String value) async {
    if (value == "Iniciar") {
      var resp =
          await ordenesProvider.cambiarEstado(widget.nrot, widget.token, value);
      print(resp);
      if (resp['code'] == 200) {
        toast('La orden esta en proceso');
      } else {
        toast('Ha surgido un inconveniente.');
      }
    }
    if (value == "Reprogramar") {
      var resp =
          await ordenesProvider.cambiarEstado(widget.nrot, widget.token, value);
      print(resp);
      if (resp['code'] == 200) {
        toast('La orden ha sido reprogramada');
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
}
