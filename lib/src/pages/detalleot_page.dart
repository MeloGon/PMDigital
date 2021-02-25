import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pmdigital_app/src/models/OrdenFullModel.dart';
import 'package:pmdigital_app/src/pages/operation_page.dart';
import 'package:pmdigital_app/src/provider/operacion_provider.dart';
import 'package:pmdigital_app/src/provider/ordenes_provider.dart';

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

// ...

class _DetallesOtPageState extends State<DetallesOtPage>
    with SingleTickerProviderStateMixin {
  Color _appBarColor = Color(0xff354A5F);

  TextStyle _styleAppBarTitle = TextStyle(
      fontFamily: 'fuente72', fontSize: 14.0, fontWeight: FontWeight.w700);

  TextStyle _styleTitleExpansibleBar = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w700, fontFamily: 'fuente72');

  TextStyle _styleLabelTab =
      TextStyle(fontFamily: 'fuente72', fontSize: 14, color: Color(0xff0854A0));

  TextStyle _oTextStyle =
      TextStyle(fontFamily: 'fuente72', fontSize: 14.0, color: Colors.black);

  TextStyle estiloMore = TextStyle(fontSize: 14, fontFamily: 'fuente72');

  TextStyle _titleOpStyle = TextStyle(
      fontSize: 14.0, color: Color(0xff32363A), fontWeight: FontWeight.w700);

  OrdenesProvider ordenesProvider = new OrdenesProvider();
  OperacionMaterialProvider operacionMaterialProvider =
      new OperacionMaterialProvider();

  OrdenFullModel resp;
  OrdenFullModel ot = new OrdenFullModel();

  Color _greyColor = Color(0xff6A6D70);
  Color colorLabelTab = Color(0xff0854A0);

  ScrollController _scrollController = new ScrollController();

  String estadoOperaciones = "";
  String estadoDetalles = '';

  String estadoBoton = '';
  List<Operacion> listaOperacion = new List<Operacion>();
  List<Materiale> listaMats = new List<Materiale>();

  @override
  void initState() {
    super.initState();
    cargarDetalles();
    cargarOperaciones();
    cargarMateriales();
    cerrarot();
    estadoDetalles = widget.estado;
    if (estadoDetalles == "En proceso") {
      estadoBoton = "Finalizar";
    }
    if (estadoDetalles == "Pendiente") {
      estadoBoton = "Iniciar Orden de Trabajo";
    }
    if (estadoDetalles == "Completado") {
      estadoBoton = "Finalizada";
    }
    _scrollController = new ScrollController(initialScrollOffset: 395);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  cargarDetalles() async {
    setState(() {
      ordenesProvider.obtenerOrden(widget.nrot, widget.token);
    });
  }

  cerrarot() async {
    await ordenesProvider.obtenerOrden(widget.nrot, widget.token).then((value) {
      setState(() {
        ot = value;
        estadoDetalles = ot.estado;
      });
    });
  }

  cargarOperaciones() async {
    await operacionMaterialProvider
        .obtenerOperaciones(widget.nrot, widget.token)
        .then((value) {
      setState(() {
        listaOperacion = value;
      });
    });
  }

  cargarMateriales() async {
    await operacionMaterialProvider
        .obtenerMateriales(widget.nrot, widget.token)
        .then((value) {
      setState(() {
        listaMats = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          DefaultTabController(
            length: 2,
            child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      centerTitle: false,
                      leading: FlatButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          )),
                      backgroundColor: _appBarColor,
                      title: Text(
                        'Orden ${widget.nrot}',
                        style: TextStyle(fontFamily: 'fuente72', fontSize: 17),
                      ),
                      expandedHeight: 520.0,
                      floating: false,
                      pinned: true,
                      bottom: PreferredSize(
                        preferredSize: Size(70.0, 70.0),
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 25,
                          ),
                        ),
                      ),
                      flexibleSpace: futureBuilderDetalles(),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          labelColor: colorLabelTab,
                          indicatorColor: colorLabelTab,
                          labelStyle: estiloMore,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(
                              text: "OPERACIONES (${widget.cantOp})",
                            ),
                            Tab(text: "MATERIALES (${widget.cantMat})"),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: new Container(
                    child: new TabBarView(children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
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
                        ),
                        listaOperaciones(context),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
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
                                'Cantidad',
                                style: _oTextStyle,
                              ),
                            ],
                          ),
                        ),
                        listaMateriales(context),
                      ],
                    ),
                  ),
                ]))),
          ),
          barraFlotante(),
        ]),
      ),
    );
  }

  Widget barraFlotante() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Container(
          alignment: Alignment.bottomCenter,
          height: 60,
          width: double.infinity,
          child: _options(context, estadoDetalles),
        ),
      ),
    );
  }

  Widget futureBuilderDetalles() {
    return SafeArea(
      child: FutureBuilder(
          future: ordenesProvider.obtenerOrden(widget.nrot, widget.token),
          builder:
              (BuildContext context, AsyncSnapshot<OrdenFullModel> snapshot) {
            if (snapshot.hasData) {
              resp = snapshot.data;
              return _panelDetalle(resp);
            } else {
              return Container(
                  height: 100.0,
                  child: Center(child: CircularProgressIndicator()));
            }
          }),
    );
  }

  Widget _panelDetalle(OrdenFullModel resp) {
    estadoDetalles = resp.estado;
    return SafeArea(
      child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          margin: EdgeInsets.only(top: 55),
          color: Colors.white,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                child: Text(
                  widget.descriot,
                  overflow: TextOverflow.ellipsis,
                  style: _styleTitleExpansibleBar,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${resp.estado}',
                style: TextStyle(color: Hexcolor('${resp.estadoColor}')),
              ),
              SizedBox(
                height: 15,
              ),
              Text('Detalles de la orden', style: _styleAppBarTitle),
              SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(style: _oTextStyle, children: [
                  TextSpan(
                      text: 'Main Work Ctr: ',
                      style: TextStyle(color: _greyColor)),
                  TextSpan(text: '${resp.mainWork ?? ""}'),
                ]),
              ),
              SizedBox(
                height: 7,
              ),
              RichText(
                text: TextSpan(style: _oTextStyle, children: [
                  TextSpan(
                      text: 'Tipo de orden: ',
                      style: TextStyle(color: _greyColor)),
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
              Text('Programación', style: _styleAppBarTitle),
              SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(style: _oTextStyle, children: [
                  TextSpan(
                      text: 'Inicio: ', style: TextStyle(color: _greyColor)),
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
                  TextSpan(
                      text: 'Revision: ', style: TextStyle(color: _greyColor)),
                  TextSpan(text: '${resp.revision ?? ""}'),
                ]),
              ),
              SizedBox(
                height: 15,
              ),
              Text('Equipo de Referencia', style: _styleAppBarTitle),
              SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(style: _oTextStyle, children: [
                  TextSpan(
                      text: 'Ubic. func: ',
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
                      text: 'Sort field: ',
                      style: TextStyle(color: _greyColor)),
                  TextSpan(text: '${resp.sortField ?? ""}'),
                ]),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          )),
    );
  }

  Widget listaOperaciones(BuildContext context) {
    return FutureBuilder(
        future: operacionMaterialProvider.obtenerOperaciones(
            widget.nrot, widget.token),
        builder:
            (BuildContext context, AsyncSnapshot<List<Operacion>> snapshot) {
          if (snapshot.hasData) {
            // print(operaciones[0].descripcion);return Center(child: Text('si hay operaciones'),);
            if (listaOperacion.length == 0) {
              return Container(
                height: 400,
                child: Center(
                    child: Text(
                  'Actualmente no hay Operaciones disponibles',
                  style: TextStyle(
                      fontFamily: 'fuente72',
                      fontSize: 13.0,
                      color: Colors.black),
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
              itemCount: listaOperacion.length,
              itemBuilder: (context, i) {
                return itemOpe(listaOperacion[i]);
              },
            );
          } else {
            return Container(
                height: 100, child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget itemOpe(Operacion operacion) {
    estadoOperaciones = operacion.estadoOp;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OperacionPage(
            token: widget.token,
            idop: operacion.id.toString(),
            descriop: operacion.descripcion,
            estadop: operacion.estadoOp,
            nrop: operacion.actividad,
            estadot: estadoDetalles,
            nrot: widget.nrot,
          );
        })).then((value) {
          cargarOperaciones();
          setState(() {
            cerrarot();
          });
        });
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
                value: estadoOperaciones == "Terminado" ? true : false,
                onChanged: (bool value) {
                  setState(() {
                    if (value) {
                      estadoOperaciones = "Pendiente";
                    } else {
                      estadoOperaciones = "Terminado";
                    }
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
    print(listaMats);
    return FutureBuilder(
        future: operacionMaterialProvider.obtenerMateriales(
            widget.nrot, widget.token),
        builder:
            (BuildContext context, AsyncSnapshot<List<Materiale>> snapshot) {
          if (snapshot.hasData) {
            if (listaMats.length == 0) {
              return Container(
                height: 400,
                child: Center(
                    child: Text(
                  'Actualmente no hay Materiales disponibles',
                  style: TextStyle(
                      fontFamily: 'fuente72',
                      fontSize: 13.0,
                      color: Colors.black),
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
              itemCount: listaMats.length,
              itemBuilder: (context, i) {
                return itemMate(listaMats[i]);
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

  Widget _options(BuildContext context, String estado) {
    // String estadoBoton = "";
    // print(estado);
    // setState(() {
    //   print(estado);
    //   if (estado == "En proceso") {
    //     estadoBoton = "Finalizar";
    //   }
    //   if (estado == "Pendiente") {
    //     estadoBoton = "Iniciar";
    //   }
    //   if (estado == "Completado") {
    //     estadoBoton = "Finalizada";
    //   }
    // });

    //esta si sirve
    // print('el estado es $estadoDetalles');
    // setState(() {
    //   if (estadoDetalles == "En proceso") {
    //     estadoBoton = "Finalizar";
    //   }
    //   if (estadoDetalles == "Pendiente") {
    //     estadoBoton = "Iniciar";
    //   }
    //   if (estadoDetalles == "Completado") {
    //     estadoBoton = "Finalizada";
    //   }
    // });
    setState(() {
      if (estadoDetalles == "Completado") {
        estadoBoton = "Finalizada";
      }
    });

    return Container(
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
              color: Colors.grey, blurRadius: 10.0, spreadRadius: 1.0),
        ],
      ),
      // child: Card(
      //   elevation: 29.0,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: <Widget>[
      //           estadoDetalles != "Completado"
      //               ? FlatButton(
      //                   onPressed: () {
      //                     setState(() {
      //                       cambiarEstado('Iniciar Orden de Trabajo');
      //                       // estadoDetalles = 'En proceso';
      //                       estadoBoton = 'Finalizar';
      //                     });
      //                   },
      //                   child: Text(
      //                     estadoBoton,
      //                     style: TextStyle(
      //                         fontFamily: 'fuente72', color: Color(0xff0854A0)),
      //                   ),
      //                 )
      //               : FlatButton(
      //                   onPressed: null,
      //                   child: Text(estadoBoton,
      //                       style: TextStyle(color: Colors.grey)),
      //                 ),
      //         ],
      //       )
      //     ],
      //   ),
      // ),
      child: Card(
        elevation: 29.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                estadoDetalles != "Completado"
                    ? FlatButton(
                        onPressed: () {
                          setState(() {
                            if (estadoBoton == 'Finalizada') {
                              toast('Accion no permitida. Orden Finalizada');
                            } else {
                              showAlertDialog(context);
                            }
                            // estadoDetalles = 'En proceso';
                          });
                        },
                        child: Text(
                          estadoBoton,
                          style: TextStyle(
                              fontFamily: 'fuente72', color: Color(0xff0854A0)),
                        ),
                      )
                    : FlatButton(
                        onPressed: null,
                        child: Text(estadoBoton,
                            style: TextStyle(color: Colors.grey)),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void cambiarEstado(String value) async {
    if (value == "Iniciar Orden de Trabajo") {
      value = "Iniciar";
      var resp =
          await ordenesProvider.cambiarEstado(widget.nrot, widget.token, value);
      print(resp);
      if (resp['code'] == 200) {
        toast('La orden esta en proceso');
      } else {
        toast('Ha surgido un inconveniente.');
      }
    } else {
      value = "Finalizar";
      var resp =
          await ordenesProvider.cambiarEstado(widget.nrot, widget.token, value);
      print(resp);
      if (resp['code'] == 200) {
        toast('La orden se ha finalizado');
      } else {
        toast('Ha surgido un inconveniente.');
      }
    }

    cargarDetalles();
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

  showAlertDialog(BuildContext context) {
    var textoBtn = "Esta seguro de que desea iniciar la Orden de trabajo?";
    if (estadoBoton == "Finalizar") {
      textoBtn = "Esta seguro de que desea finalizar la Orden de trabajo?";
    }

    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget continueButton = FlatButton(
      child: Text("Confirmar"),
      onPressed: () async {
        if (textoBtn ==
            "Esta seguro de que desea finalizar la Orden de trabajo?") {
          cambiarEstado('Finalizar');
          estadoBoton = 'Finalizada';
        } else {
          cambiarEstado('Iniciar Orden de Trabajo');
          estadoBoton = 'Finalizar';
        }

        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmacion de Cambio de Estado",
          style: TextStyle(fontFamily: 'fuente72', fontSize: 18)),
      content: Text(textoBtn,
          style: TextStyle(fontFamily: 'fuente72', fontSize: 14)),
      actions: [
        cancelButton,
        continueButton,
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
