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
import 'package:pmdigital_app/src/provider/ordenes_provider.dart';

import 'image_network.dart';

class OperacionPage extends StatefulWidget {
  String token;
  String idop;
  String descriop;
  String estadop;
  String nrop;
  String estadot;
  String nrot;

  OperacionPage(
      {this.token,
      this.idop,
      this.descriop,
      this.estadop,
      this.nrop,
      this.estadot,
      this.nrot});
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

class _OperacionPageState extends State<OperacionPage>
    with SingleTickerProviderStateMixin {
  var formater = new DateFormat('MMM d, yyyy • hh:mm');

  TextStyle _styleTitleExpansibleBar = TextStyle(
      fontFamily: 'fuente72', fontSize: 14.0, fontWeight: FontWeight.w700);

  TextStyle _styleAppBarTitle = TextStyle(
      fontFamily: 'fuente72', fontSize: 14.0, fontWeight: FontWeight.w400);

  TextStyle _styleLabelTab =
      TextStyle(fontFamily: 'fuente72', fontSize: 13, color: Color(0xff0854A0));

  TextStyle _oTextStyle =
      TextStyle(fontFamily: 'fuente72', fontSize: 14.0, color: Colors.black);

  TextStyle estiloMore = TextStyle(fontSize: 14, fontFamily: 'fuente72');

  TextStyle styleContador = TextStyle(fontFamily: 'fuente72', fontSize: 18.0);

  Color _greyColor = Color(0xff6A6D70);
  Color colorLabelTab = Color(0xff0854A0);
  Color _appBarColor = Color(0xff354A5F);

  final OperacionMaterialProvider operacionMaterialProvider =
      new OperacionMaterialProvider();

  final OrdenesProvider ordenesProvider = new OrdenesProvider();

  File foto;

  bool loading;
  bool open = false;
  bool operacionesTerminadas = false;

  List<String> ids;

  var provFotos;
  var provNotas;
  var provMats;
  var provServ;

  List<Nota> listaNotas = new List<Nota>();
  List<Foto> listaFotos = new List<Foto>();
  List<Servicio> listaServ = new List<Servicio>();
  List<Materiale> listaMats = new List<Materiale>();

  ScrollController _scrollController = new ScrollController();
  //TabController _tabController;

  int currentIndex = 0;

  OperacionFullModel resp;

  String estado = "";
  String estadoDetalles = '';
  String estadoBoton = '';

  bool btn = true;

  @override
  void initState() {
    // _tabController = TabController(length: 4, vsync: this);

    // _tabController.addListener(() {
    //   currentIndex = _tabController.index;
    //   print('indice' + currentIndex.toString());
    // });

    _scrollController = new ScrollController(initialScrollOffset: 455);
    estado = widget.estadop;
    estadoDetalles = widget.estadot;
    iniciarProviders();
    cargarNotas();
    cargarFotos();
    cargarServicios();
    cargarMateriale();
    super.initState();
  }

  cargarDetalles() async {
    setState(() {
      operacionMaterialProvider.obtenerOperacion(widget.idop, widget.token);
    });
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

  cargarServicios() async {
    await operacionMaterialProvider
        .obtenerServiciosOperacion(widget.idop, widget.token)
        .then((value) {
      setState(() {
        listaServ = value;
      });
    });
  }

  cargarMateriale() async {
    await operacionMaterialProvider
        .obtenerMaterialesOperacion(widget.idop, widget.token)
        .then((value) {
      setState(() {
        listaMats = value;
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
  void dispose() {
    _scrollController.dispose();
    // _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          DefaultTabController(
            length: 4,
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
                      title: Text('Operacion ${widget.nrop}',
                          style:
                              TextStyle(fontFamily: 'fuente72', fontSize: 17)),
                      expandedHeight: 550.0,
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
                          // controller: _tabController,
                          isScrollable: true,
                          labelColor: colorLabelTab,
                          indicatorColor: colorLabelTab,
                          labelStyle: estiloMore,
                          unselectedLabelColor: Colors.grey,
                          tabs: tabs(),
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: new Container(
                    margin: EdgeInsets.only(bottom: 65),
                    child: new TabBarView(children: <Widget>[
                      listaServices(context),
                      listaMaterialess(context),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            FutureBuilder(
                                future: provNotas,
                                builder: (context,
                                    AsyncSnapshot<List<Nota>> snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                        height: 40.0,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            popNota(),
                                          ],
                                        ));
                                  } else {
                                    return Container(
                                        height: 40.0,
                                        padding: EdgeInsets.only(left: 20.0),
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,
                                        child: Text(
                                          '',
                                          style: styleContador,
                                        ));
                                  }
                                }),
                            listaNotes(context),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            FutureBuilder(
                                future: provFotos,
                                builder: (context,
                                    AsyncSnapshot<List<Foto>> snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                        height: 50.0,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            popFoto(),
                                          ],
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
                                }),
                            listaPhotos(context),
                          ],
                        ),
                      ),
                    ]))),
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
        ]),
      ),
    );
  }

  List<Tab> tabs() {
    List<Tab> tb = [
      Tab(
        text: "SERVICIOS (${listaServ.length})",
      ),
      Tab(
        text: "MATERIALES (${listaMats.length})",
      ),
      Tab(
        text: "NOTAS (${listaNotas.length})",
      ),
      Tab(
        text: "FOTOS (${listaFotos.length})",
      ),
    ];
    return tb;
  }

  Widget futureBuilderDetalles() {
    return FutureBuilder(
      future:
          operacionMaterialProvider.obtenerOperacion(widget.idop, widget.token),
      builder: (context, AsyncSnapshot<OperacionFullModel> snapshot) {
        if (snapshot.hasData) {
          resp = snapshot.data;
          return _panelDetalle(resp);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _panelDetalle(OperacionFullModel resp) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        margin: EdgeInsets.only(top: 55),
        width: double.infinity,
        color: Colors.white,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Text(
              widget.descriop,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: 'fuente72',
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 9,
            ),
            Text('${resp.estadoOp}'),
            SizedBox(
              height: 20,
            ),
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
                TextSpan(text: '${resp.operationWorkCenter ?? ""}'),
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
                TextSpan(text: '${resp.fechaIniPlan ?? ""}'),
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
                    text: 'Duracion: ', style: TextStyle(color: _greyColor)),
                TextSpan(text: '${resp.duracionReal ?? ""}'),
              ]),
            ),
            SizedBox(
              height: 7,
            ),
            RichText(
              text: TextSpan(style: _oTextStyle, children: [
                TextSpan(
                    text: 'Personal: ', style: TextStyle(color: _greyColor)),
                TextSpan(text: '${resp.numberReal ?? ""}'),
              ]),
            ),
            SizedBox(
              height: 7,
            ),
            RichText(
              text: TextSpan(style: _oTextStyle, children: [
                TextSpan(
                    text: 'Trabajo: ', style: TextStyle(color: _greyColor)),
                TextSpan(text: '${resp.workReal ?? ""}'),
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
                TextSpan(text: '${resp.ubiFuncional ?? ""}'),
              ]),
            ),
            SizedBox(
              height: 7,
            ),
            RichText(
              text: TextSpan(style: _oTextStyle, children: [
                TextSpan(
                    text: 'Descripcion: ', style: TextStyle(color: _greyColor)),
                TextSpan(text: '${resp.descripcionEquipo ?? ""}'),
              ]),
            ),
            SizedBox(
              height: 7,
            ),
            RichText(
              text: TextSpan(style: _oTextStyle, children: [
                TextSpan(
                    text: 'Sort Field: ', style: TextStyle(color: _greyColor)),
                TextSpan(text: '${resp.sortField ?? ""}'),
              ]),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget listaServices(BuildContext context) {
    return FutureBuilder(
      future: provServ,
      builder: (context, AsyncSnapshot<List<Servicio>> snapshot) {
        if (snapshot.hasData) {
          if (listaServ.length == 0) {
            return Center(
              child: Text('Actualmente no hay Servicios disponibles'),
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
            itemCount: listaServ.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return itemServicio(listaServ[index]);
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

  Widget listaMaterialess(BuildContext context) {
    return FutureBuilder(
      future: provMats,
      builder: (context, AsyncSnapshot<List<Materiale>> snapshot) {
        if (snapshot.hasData) {
          if (listaMats.length == 0) {
            return Center(
              child: Text('Actualmente no hay Materiales disponibles'),
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
            itemCount: listaMats.length,
            itemBuilder: (context, index) {
              return itemMat(listaMats[index]);
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
      visualDensity: VisualDensity(horizontal: 3, vertical: -3),
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
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  Widget listaNotes(BuildContext context) {
    return FutureBuilder(
      future: provNotas,
      builder: (context, AsyncSnapshot<List<Nota>> snapshot) {
        if (snapshot.hasData) {
          if (listaNotas.length == 0) {
            return Container(
              height: 480,
              child: Center(
                child: Text('Actualmente no hay Notas disponibles'),
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
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
      visualDensity: VisualDensity(horizontal: 3, vertical: -3),
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

  Widget popNota() {
    return PopupMenuButton<String>(
      child: Icon(
        Icons.add,
        size: 27,
      ),
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
    if (estadoDetalles != "Completado" && estadoDetalles != "Pendiente") {
      if (value == "añadir_nota") {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return NotaPage(
            token: widget.token,
            idop: widget.idop,
          );
        })).then((value) {
          cargarNotas();
          tabs();
        });
      }
    } else {
      if (value == "añadir_nota") {
        toast('Acción no permitida');
      }
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
      })).then((value) => cargarNotas());
    }
  }

  Widget listaPhotos(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 500,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: FutureBuilder(
          future: provFotos,
          builder: (context, AsyncSnapshot<List<Foto>> snapshot) {
            if (snapshot.hasData) {
              if (listaFotos.length == 0) {
                return Center(
                  child: Text('Actualmente no hay Fotografias disponibles'),
                );
              }
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: listaFotos.length,
                  itemBuilder: (context, index) {
                    return itemFoto(listaFotos[index]);
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget itemFoto(Foto data) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5.0),
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

  Widget popFoto() {
    return PopupMenuButton<String>(
      child: Icon(
        Icons.add,
        size: 27,
      ),
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
    if (estadoDetalles != "Completado" && estadoDetalles != "Pendiente") {
      if (value == "tomar_foto") {
        tomarFoto();
      }
      if (value == "escoger_foto") {
        seleccionarFoto();
      }
    } else {
      if (value == "tomar_foto") {
        toast('Acción no permitida');
      }
      if (value == "escoger_foto") {
        toast('Acción no permitida');
      }
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
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImagePage(foto, widget.token, widget.idop);
      })).then((value) {
        cargarFotos();
        tabs();
      });

      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return ImagePage(foto, widget.token, widget.idop);
      //     },
      //   ),
      // ).then((value) => cargarFotos());
    } else {
      print('ruta de imagen nula');
    }
  }

  Widget _options(BuildContext context) {
    setState(() {
      if (estado == "Terminado") {
        estadoBoton = "No Confirmado";
      }
      if (estado == 'Pendiente') {
        estadoBoton = 'Confirmar';
      }
    });

    // return Container(
    //   decoration: new BoxDecoration(
    //     boxShadow: [
    //       new BoxShadow(
    //           color: Colors.grey, blurRadius: 10.0, spreadRadius: 1.0),
    //     ],
    //   ),
    //   child: Card(
    //     elevation: 29.0,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
    //     child: Column(
    //       children: <Widget>[
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: <Widget>[
    //             estadoDetalles == 'En proceso'
    //                 ? FlatButton(
    //                     onPressed: () {
    //                       if (btn) {

    //                         cambiarEstadoOp(estado, estadoBoton);
    //                         estado = 'Terminado';
    //                         estadoBoton = 'No Confirmado';
    //                         btn = false;
    //                       } else {
    //                         cambiarEstadoOp(estado, estadoBoton);
    //                         estado = 'Pendiente';
    //                         estadoBoton = 'Confirmar';
    //                         btn = true;
    //                       }
    //                     },
    //                     child: Text(
    //                       estadoBoton,
    //                       style: TextStyle(
    //                           fontSize: 15,
    //                           fontFamily: 'fuente72',
    //                           color: Color(0xff0854A1)),
    //                     ))
    //                 : FlatButton(
    //                     onPressed: null,
    //                     child: Text(
    //                       estadoDetalles == "Pendiente"
    //                           ? 'Confirmar'
    //                           : 'No confirmar',
    //                       style: TextStyle(
    //                           fontSize: 15,
    //                           fontFamily: 'fuente72',
    //                           color: Colors.grey),
    //                     )),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
    return Container(
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
              color: Colors.grey, blurRadius: 10.0, spreadRadius: 1.0),
        ],
      ),
      child: Card(
        elevation: 29.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                estadoDetalles == 'En proceso'
                    ? FlatButton(
                        onPressed: () {
                          showAlertDialog(context);
                          // if (btn) {

                          //   cambiarEstadoOp(estado, estadoBoton);
                          //   estado = 'Terminado';
                          //   estadoBoton = 'No Confirmado';
                          //   btn = false;
                          // } else {
                          //   cambiarEstadoOp(estado, estadoBoton);
                          //   estado = 'Pendiente';
                          //   estadoBoton = 'Confirmar';
                          //   btn = true;
                          // }
                        },
                        child: Text(
                          estadoBoton,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'fuente72',
                              color: Color(0xff0854A1)),
                        ))
                    : FlatButton(
                        onPressed: null,
                        child: Text(
                          estadoDetalles == "Pendiente"
                              ? 'Confirmar'
                              : 'No confirmar',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'fuente72',
                              color: Colors.grey),
                        )),
              ],
            )
          ],
        ),
      ),
    );
  }

  void cambiarEstadoOp(String value, String estBtn) async {
    var num;
    //if (value == "Confirmar") {
    if (value == "Pendiente" && estBtn == 'Confirmar') {
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
    //if (value == "No Confirmar") {
    if (value == "Terminado" && estBtn == 'No Confirmado') {
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

    revisionCheck();

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

  revisionCheck() async {
    operacionesTerminadas = await operacionMaterialProvider
        .comprobarEstadoOperaciones(widget.nrot, widget.token);
    if (operacionesTerminadas) {
      showAlertDialogOperaciones(context);
    }
  }

  showAlertDialog(BuildContext context) {
    var textoBtn = "Esta seguro de que desea confirmar la Operacion?";
    if (estadoBoton == "No Confirmado") {
      textoBtn = "Esta seguro de que desea no confirmar la Operacion?";
    }

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Confirmar"),
      onPressed: () async {
        if (btn) {
          cambiarEstadoOp(estado, estadoBoton);
          estado = 'Terminado';
          estadoBoton = 'No Confirmado';
          btn = false;
        } else {
          cambiarEstadoOp(estado, estadoBoton);
          estado = 'Pendiente';
          estadoBoton = 'Confirmar';
          btn = true;
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

  showAlertDialogOperaciones(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Confirmar"),
      onPressed: () async {
        ordenesProvider.cambiarEstado(widget.nrot, widget.token, "Finalizar");
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmacion de Cambio de Estado",
          style: TextStyle(fontFamily: 'fuente72', fontSize: 18)),
      content: Text('Desea Finalizar la Orden de trabajo',
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
