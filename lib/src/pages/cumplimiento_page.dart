import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:pmdigital_app/src/models/OrdenModel.dart';
import 'package:pmdigital_app/src/pages/filtros_page.dart';
import 'package:pmdigital_app/src/provider/ordenes_provider.dart';

import 'detalleot_page.dart';

class CumplimientoPage extends StatefulWidget {
  final String token;
  CumplimientoPage({this.token});
  @override
  _CumplimientoPageState createState() => _CumplimientoPageState();
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

List<Item> _data = generateItems(1);

class _CumplimientoPageState extends State<CumplimientoPage> {
  Color _appBarColor = Color(0xff354A5F);
  Color _greyColor = Color(0xff6A6D70);
  TextStyle _oTextStyle =
      TextStyle(fontFamily: 'fuente72', fontSize: 14.0, color: Colors.black);

  TextStyle _titleOtStyle = TextStyle(
      fontFamily: 'fuente72',
      color: Color(0xff32363A),
      fontWeight: FontWeight.w700);

  TextStyle _estiloItemNro = TextStyle(
      fontSize: 16,
      fontFamily: 'fuente72',
      fontWeight: FontWeight.w700,
      color: Color(0xff0A6ED1));

  TextStyle _estiloItemDescr = TextStyle(
      fontSize: 14, fontFamily: 'fuente72', fontWeight: FontWeight.w700);
  final ordenesProvider = new OrdenesProvider();
  List<String> cantOpyMat = [];
  TextEditingController editingController = TextEditingController();
  List<OrdenModel> listaOrdenToda = new List<OrdenModel>();
  List<OrdenModel> listaOrdenTodaFiltrada = new List<OrdenModel>();
  DateFormat f = new DateFormat('yyyy-MM-dd');
  DateTime selectedDate = DateTime.now();
  String _fecha = '';
  String opcionSeleccionada;
  TextEditingController _inputFieldDateController = new TextEditingController();

  List<OrdenModel> temporal = List<OrdenModel>();
  List<OrdenModel> temporalTwo = List<OrdenModel>();
  List<OrdenModel> temporalThree = List<OrdenModel>();
  List<OrdenModel> temporalFour = List<OrdenModel>();

  List<OrdenModel> listConStat = List<OrdenModel>();
  List<OrdenModel> listConFech = List<OrdenModel>();
  List<OrdenModel> listaValida = List<OrdenModel>();

  String statusFiltro = "";
  String fechaFiltro = "";
  bool botonFiltro = false;
  String buscar = "";

  int code = 0;

  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);

    cargarInOrdenes();
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
    if (!_focus.hasFocus) {
      temporalTwo.addAll(listaOrdenTodaFiltrada);
    }
  }

  @override
  void dispose() {
    editingController.dispose();
    _inputFieldDateController.dispose();
    super.dispose();
  }

  cargarInOrdenes() async {
    //ordenesProvider.getOrdenes(widget.token);
    ordenesProvider.cargarOrdenes(widget.token).then((value) {
      setState(() {
        listaOrdenToda = value;
        listaOrdenTodaFiltrada.addAll(listaOrdenToda);
        temporalFour.addAll(listaOrdenToda);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ordenesProvider.getOrdenes(widget.token);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, true),
          ),
          backgroundColor: _appBarColor,
          centerTitle: false,
          title: Text(
            'Cumplimiento del programa',
            style: TextStyle(fontFamily: 'fuente72', fontSize: 17),
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.more_horiz_outlined),
          //     onPressed: () {
          //       Navigator.push(context, MaterialPageRoute(builder: (context) {
          //         return FiltroPage(
          //           lista: listaOrdenTodaFiltrada,
          //         );
          //       }));
          //     },
          //   )
          // ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              cuerpoPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget cuerpoPage() {
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
                  'Órdenes de trabajo (${listaOrdenTodaFiltrada.length})',
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
          listaOrdenes(),
        ],
      ),
    );
  }

  Widget contenidoPanelExpansible() {
    Widget containerBuscar = Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      height: 48,
      child: TextField(
        focusNode: _focus,
        onChanged: (value) {
          buscar = value;
          filterSearchResults(value);
          //filterSearchResultsXXX(value, 1);
        },
        controller: editingController,
        decoration: InputDecoration(
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
                        //filterSearchResultsXXX("", 1);
                      });
                    },
                    icon: Icon(
                      Icons.clear,
                    ),
                  ),
            hintText: 'Buscar',
            hintStyle: TextStyle(
                fontFamily: 'fuente72',
                fontSize: 14.0,
                color: Colors.black,
                fontStyle: FontStyle.italic),
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder()),
      ),
    );

    _selectDate(BuildContext context) async {
      DateTime picked = await showDatePicker(
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: const Color(0xff354A5F),
                accentColor: const Color(0xff354A5F),
                colorScheme:
                    ColorScheme.light(primary: const Color(0xff354A5F)),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child,
            );
          },
          context: context,
          initialDate: selectedDate,
          firstDate: new DateTime(2000),
          lastDate: new DateTime(2030),
          locale: Locale('es', 'ES'));

      if (picked != null && picked != selectedDate) {
        setState(() {
          // _fecha = picked.toString();
          _fecha = DateFormat('yyyy-MM-dd').format(picked);
          print(_fecha);
          _inputFieldDateController.text = _fecha;
          selectedDate = picked;
        });
      }
      //filterSearchResultsXXX(_inputFieldDateController.text, 3);
      fechaFiltro = _inputFieldDateController.text;
      // fechaSeleccionada(_inputFieldDateController.text);
      // listConFech.addAll(listaOrdenTodaFiltrada);
    }

    Widget containerFecha = Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      height: 48,
      child: TextField(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
        enableInteractiveSelection: false,
        controller: _inputFieldDateController,
        decoration: InputDecoration(
            hintText: 'Seleccione la fecha',
            hintStyle: TextStyle(
                fontFamily: 'fuente72', fontSize: 14.0, color: Colors.black),
            suffixIcon: Icon(Icons.date_range),
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder()),
      ),
    );

    List<DropdownMenuItem<String>> getOpcionesDropdownPrioridad() {
      List<DropdownMenuItem<String>> listaPri = new List();

      listaPri.add(DropdownMenuItem(
        child: Text("Seleccione"),
        value: "Seleccione",
      ));

      return listaPri;
    }

    List<DropdownMenuItem<String>> getOpcionesDropdownStatus() {
      List<DropdownMenuItem<String>> listaSta = new List();

      listaSta.add(
        DropdownMenuItem(
          child: Text("Seleccione"),
          value: "Seleccione",
        ),
      );

      listaSta.add(
        DropdownMenuItem(
          child: Text("Pendiente"),
          value: "Pendiente",
        ),
      );
      listaSta.add(
        DropdownMenuItem(
          child: Text("En proceso"),
          value: "En proceso",
        ),
      );
      listaSta.add(
        DropdownMenuItem(
          child: Text("Completado"),
          value: "Completado",
        ),
      );
      listaSta.add(
        DropdownMenuItem(
          child: Text("Reprogramado"),
          value: "Reprogramado",
        ),
      );

      return listaSta;
    }

    Widget containerPrioridad = Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      height: 48,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: DropdownButton(
          // hint: Text('Seleccione ...'),
          hint: Text(
            'Seleccione',
            style: TextStyle(color: Colors.black),
          ),
          style: TextStyle(fontFamily: 'fuente72', color: Colors.black),
          //value: _opcionSeleccionada ?? _poderes.first.descripcion,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          isExpanded: true,
          items: getOpcionesDropdownPrioridad(),
          onChanged: (opt) {
            setState(() {});
          },
        ),
      ),
    );

    Widget containerStatus = Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      height: 48,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: DropdownButton(
          // hint: Text('Seleccione ...'),
          hint: Text(
            '${opcionSeleccionada ?? "Seleccione"}',
            style: TextStyle(color: Colors.black),
          ),
          style: TextStyle(fontFamily: 'fuente72', color: Colors.black),
          //value: _opcionSeleccionada ?? _poderes.first.descripcion,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          isExpanded: true,
          items: getOpcionesDropdownStatus(),
          onChanged: (opt) {
            setState(() {
              opcionSeleccionada = opt;
              if (opcionSeleccionada == "Seleccione") {
                statusFiltro = "";
              } else {
                statusFiltro = opcionSeleccionada;
              }

              print(statusFiltro);
              // temporal.addAll(listaOrdenTodaFiltrada);
              // statusFiltro = opt;
              // statusSeleccionado(opcionSeleccionada);
              // listConStat.addAll(listaOrdenTodaFiltrada);
              // if (opt == "Seleccione") {
              //   listConStat.clear();
              //   // statusSeleccionado("Seleccione");
              //   // temporal.clear();
              //   // temporal.addAll(temporalTwo.length == 0
              //   //     ? listaOrdenTodaFiltrada
              //   //     : temporalTwo);

              //   // temporalTwo.clear();

              //   // filterSearchResultsXXX("", 2);
              // } else {
              //   //statusSeleccionado(opt);

              //   // filterSearchResultsXXX("", 2);
              // }
            });
          },
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          containerBuscar,
          SizedBox(
            height: 9,
          ),
          Text('Fecha:', style: TextStyle(fontFamily: 'fuente72')),
          containerFecha,
          SizedBox(
            height: 9,
          ),
          Text('Prioridad:', style: TextStyle(fontFamily: 'fuente72')),
          containerPrioridad,
          SizedBox(
            height: 9,
          ),
          Text('Estatus:', style: TextStyle(fontFamily: 'fuente72')),
          containerStatus,
          SizedBox(
            height: 9,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: FlatButton(
                    textColor: Color(0xff0A6ED1),
                    child: Text('Restablecer'),
                    onPressed: () {
                      listaValida.clear();
                      botonFiltro = false;
                      fechaFiltro = "";
                      statusFiltro = "";
                      toast('Restableciendo Filtros', Colors.black,
                          Colors.grey[300]);
                      _fecha = "";
                      selectedDate = DateTime.now();
                      _inputFieldDateController.text = "";
                      temporal.clear();
                      temporalTwo.clear();
                      editingController.text = "";
                      opcionSeleccionada = 'Seleccione';
                      statusSeleccionado(opcionSeleccionada);
                      listaOrdenTodaFiltrada.clear();
                      cargarInOrdenes();
                    }),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 50,
                  child: RaisedButton(
                      color: Color(0xff0A6ED1),
                      textColor: Colors.white,
                      child: Text('Ir'),
                      onPressed: () {
                        botonFiltro = true;
                        listaValida.addAll(listaOrdenTodaFiltrada);
                        toast('Aplicando Filtros', Colors.black,
                            Colors.grey[300]);
                        filterSearchResultsTwo(
                            statusFiltro, fechaFiltro, buscar);
                      }),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }

  Widget listaOrdenes() {
    return Container(
        width: double.infinity,
        height: 650,
        child: FutureBuilder(
            future: ordenesProvider.cargarOrdenes(widget.token),
            builder: (BuildContext context,
                AsyncSnapshot<List<OrdenModel>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: listaOrdenTodaFiltrada.length,
                  itemBuilder: (context, i) {
                    return itemOt(listaOrdenTodaFiltrada[i]);
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
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
          })).then((value) {
            /*  listaOrdenTodaFiltrada.clear();
            cargarInOrdenes(); */
            /* if (statusFiltro != "" && fechaFiltro != "" && buscar != "") {
              return;
            } else {
              filterSearchResultsTwo(statusFiltro, fechaFiltro, buscar);
            } */
            //VER ESTA ACTUALIZACION DE LA LISTA CUANDO SE REALIZA CAMBIO DE ESTADO
          });
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
            Row(
              children: <Widget>[
                RichText(
                  text: TextSpan(style: _oTextStyle, children: [
                    TextSpan(
                        text: 'Fin: ', style: TextStyle(color: _greyColor)),
                    TextSpan(text: '${f.format(orden.fechaFinPlan ?? "")}'),
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

  void filterSearchResultsXXX(String query, int code) {
    List<OrdenModel> dummySearchList = List<OrdenModel>();
    dummySearchList.addAll(listaOrdenToda);

    if (query.isNotEmpty) {
      List<OrdenModel> dummyListData = List<OrdenModel>();
      dummySearchList.forEach((item) {
        if (item.numeroOt.toLowerCase().contains(query) ||
            item.descripcion.toLowerCase().contains(query) ||
            item.tipoOt.toLowerCase().contains(query) ||
            item.estado.contains(query) ||
            item.fechaFinPlan.toString().contains(query)) {
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

  // void filterSearchResults(String query) {
  //   List<OrdenModel> dummySearchList = List<OrdenModel>();
  //   dummySearchList.addAll(listaOrdenToda);
  //   if (query.isNotEmpty) {
  //     List<OrdenModel> dummyListData = List<OrdenModel>();
  //     dummySearchList.forEach((item) {
  //       if (item.numeroOt.toLowerCase().contains(query) ||
  //           item.descripcion.toLowerCase().contains(query)) {
  //         dummyListData.add(item);
  //       }
  //     });
  //     setState(() {
  //       listaOrdenTodaFiltrada.clear();
  //       listaOrdenTodaFiltrada.addAll(dummyListData);
  //     });
  //     return;
  //   } else {
  //     setState(() {
  //       listaOrdenTodaFiltrada.clear();
  //       listaOrdenTodaFiltrada.addAll(listaOrdenToda);
  //     });
  //   }
  // }

  // void statusSeleccionado(String opt) {
  //   List<OrdenModel> dummySearchList = List<OrdenModel>();
  //   dummySearchList.addAll(temporal);

  //   if (opt.isNotEmpty && opt != "Seleccione") {
  //     print('opcion es $opt');
  //     List<OrdenModel> dummyListData = List<OrdenModel>();

  //     dummySearchList.forEach((item) {
  //       if (item.estado.contains(opt)) {
  //         dummyListData.add(item);
  //         print(dummyListData);
  //       }
  //     });
  //     setState(() {
  //       listaOrdenTodaFiltrada.clear();
  //       listaOrdenTodaFiltrada.addAll(dummyListData.toSet().toList());
  //     });
  //     return;
  //   } else if (opt == "Seleccione") {
  //     setState(() {
  //       listaOrdenTodaFiltrada.clear();
  //       //listaOrdenTodaFiltrada.addAll(temporalTwo);
  //       listaOrdenTodaFiltrada.addAll(temporalTwo.toSet().toList());
  //     });
  //   } else {
  //     setState(() {
  //       listaOrdenTodaFiltrada.clear();
  //       listaOrdenTodaFiltrada.addAll(listaOrdenToda);
  //     });
  //   }
  // }

  // void fechaSeleccionada(String opt) {
  //   List<OrdenModel> dummySearchList = List<OrdenModel>();
  //   dummySearchList.addAll(temporalFour);

  //   if (opt.isNotEmpty) {
  //     print('fechassss $opt');
  //     List<OrdenModel> dummyListData = List<OrdenModel>();
  //     dummySearchList.forEach((item) {
  //       if (item.fechaFinPlan.toString().contains(opt)) {
  //         dummyListData.add(item);
  //         print(dummyListData);
  //       }
  //     });
  //     setState(() {
  //       listaOrdenTodaFiltrada.clear();
  //       listaOrdenTodaFiltrada.addAll(dummyListData);
  //       temporalFour.addAll(listaOrdenToda);
  //     });
  //     return;
  //   } else {
  //     setState(() {
  //       listaOrdenTodaFiltrada.clear();
  //       listaOrdenTodaFiltrada.addAll(listaOrdenToda);
  //     });
  //   }
  // }

  void filterSearchResults(String query) {
    List<OrdenModel> dummySearchList = List<OrdenModel>();
    dummySearchList
        .addAll(botonFiltro == false ? listaOrdenToda : listaOrdenTodaFiltrada);
    if (query.isNotEmpty) {
      List<OrdenModel> dummyListData = List<OrdenModel>();
      dummySearchList.forEach((item) {
        if (item.numeroOt.toLowerCase().contains(query) ||
            item.descripcion.toLowerCase().contains(query)) {
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

  void filterSearchResultsTwo(String status, String fecha, String buscar) {
    List<OrdenModel> dummySearchList = List<OrdenModel>();
    dummySearchList.addAll(buscar == "" ? listaOrdenToda : listaValida);
    if (status != "" && fecha != "") {
      print("ninguno esta vacio");
      List<OrdenModel> dummyListData = List<OrdenModel>();
      dummySearchList.forEach((item) {
        if (item.estado.contains(status) &&
            item.fechaFinPlan.toString().contains(fecha)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        listaOrdenTodaFiltrada.clear();
        listaOrdenTodaFiltrada.addAll(dummyListData.toSet().toList());
      });
      return;
    } else if (status == "" && fecha != "") {
      print("no hay estaus esta vacio");
      List<OrdenModel> dummyListData = List<OrdenModel>();
      dummySearchList.forEach((item) {
        if (item.fechaFinPlan.toString().contains(fecha)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        listaOrdenTodaFiltrada.clear();
        listaOrdenTodaFiltrada.addAll(dummyListData.toSet().toList());
      });
      return;
    } else if (status != "" && fecha == "") {
      print("no hay fecha");
      List<OrdenModel> dummyListData = List<OrdenModel>();
      dummySearchList.forEach((item) {
        if (item.estado.contains(status)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        listaOrdenTodaFiltrada.clear();
        listaOrdenTodaFiltrada.addAll(dummyListData.toSet().toList());
      });
      return;
    } else {
      setState(() {
        listaOrdenTodaFiltrada.clear();
        listaOrdenTodaFiltrada.addAll(listaValida.toSet().toList());
      });
    }
  }

  void statusSeleccionado(String opt) {
    List<OrdenModel> dummySearchList = List<OrdenModel>();
    dummySearchList.addAll(fechaFiltro == "" ? temporal : listConFech);

    if (opt.isNotEmpty && opt != "Seleccione") {
      print('opcion es $opt');
      List<OrdenModel> dummyListData = List<OrdenModel>();

      dummySearchList.forEach((item) {
        if (item.estado.contains(opt)) {
          dummyListData.add(item);
          print(dummyListData);
        }
      });
      setState(() {
        listaOrdenTodaFiltrada.clear();
        listaOrdenTodaFiltrada.addAll(dummyListData.toSet().toList());
      });
      return;
    } else if (opt == "Seleccione") {
      setState(() {
        listaOrdenTodaFiltrada.clear();
        //listaOrdenTodaFiltrada.addAll(temporalTwo);
        listaOrdenTodaFiltrada.addAll(temporalTwo.toSet().toList());
      });
    } else {
      setState(() {
        listaOrdenTodaFiltrada.clear();
        listaOrdenTodaFiltrada.addAll(listaOrdenToda);
      });
    }
  }

  void fechaSeleccionada(String opt) {
    List<OrdenModel> dummySearchList = List<OrdenModel>();
    dummySearchList.addAll(statusFiltro == "" ? temporal : listConStat);

    if (opt.isNotEmpty) {
      print('fechassss $opt');
      List<OrdenModel> dummyListData = List<OrdenModel>();
      dummySearchList.forEach((item) {
        if (item.fechaFinPlan.toString().contains(opt)) {
          dummyListData.add(item);
          print(dummyListData);
        }
      });
      setState(() {
        listaOrdenTodaFiltrada.clear();
        listaOrdenTodaFiltrada.addAll(dummyListData.toSet().toList());
        temporalFour.addAll(listaOrdenToda);
      });
      return;
    } else {
      setState(() {
        listaOrdenTodaFiltrada.clear();
        listaOrdenTodaFiltrada.addAll(listaOrdenToda);
      });
    }
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

  //SEGUIR VIENDO ESO DE LOS FILTROS

}
