import 'package:flutter/material.dart';
import 'package:pmdigital_app/src/models/OrdenModel.dart';
import 'package:pmdigital_app/src/provider/ordenes_provider.dart';

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
  final ordenesProvider = new OrdenesProvider();
  @override
  Widget build(BuildContext context) {
    ordenesProvider.getOrdenes(widget.token);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        title: Text('Cumplimiento del programa'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            cuerpoPage(),
          ],
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
                  'Éstandar',
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
      child: TextFormField(
        decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            hintText: 'Buscar',
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder()),
      ),
    );

    Widget containerFecha = Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      height: 48,
      child: TextFormField(
        decoration: InputDecoration(
            suffixIcon: Icon(Icons.date_range),
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder()),
      ),
    );

    Widget containerPrioridad = Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      height: 48,
      child: TextFormField(
        decoration: InputDecoration(
            hintText: 'Todos',
            suffixIcon: Icon(Icons.keyboard_arrow_down),
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder()),
      ),
    );

    Widget containerStatus = Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      height: 48,
      child: TextFormField(
        decoration: InputDecoration(
            hintText: 'Todos',
            suffixIcon: Icon(Icons.keyboard_arrow_down),
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder()),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          containerBuscar,
          Text('Fecha'),
          containerFecha,
          Text('Prioridad'),
          containerPrioridad,
          Text('Estatus'),
          containerStatus,
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
      child: StreamBuilder(
        stream: ordenesProvider.ordenesStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<OrdenModel>> snapshot) {
          //ese signo de interrogacion dice has este foreach si existe data
          snapshot.data?.forEach((element) {
            print(element.descripcion);
          });
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return itemOt(snapshot.data[index]);
              },
            );
          } else {
            //el progrssar solo aparece mientras se resuleve el future o cuando nohay datos
            return Container(
                height: 400, child: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }

  Widget itemOt(OrdenModel data) {
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, 'detallesot');
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            Text(
              '${data.descripcion}',
              style: _titleOtStyle,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.0,
            ),
            RichText(
              text: TextSpan(style: _oTextStyle, children: [
                TextSpan(text: 'Orden: ', style: TextStyle(color: _greyColor)),
                TextSpan(text: '${data.numeroOt}'),
              ]),
            ),
            SizedBox(
              height: 5.0,
            ),
            RichText(
              text: TextSpan(style: _oTextStyle, children: [
                TextSpan(
                    text: 'Tipo Orden: ', style: TextStyle(color: _greyColor)),
                TextSpan(text: 'PM01'),
              ]),
            ),
            SizedBox(
              height: 5.0,
            ),
            RichText(
              text: TextSpan(style: _oTextStyle, children: [
                TextSpan(
                    text: 'Prioridad: ', style: TextStyle(color: _greyColor)),
                TextSpan(text: '${data.prioridad}'),
              ]),
            ),
          ],
        ),
        trailing: Container(
          width: 100.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${data.estado}',
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: Color(0xffBB0000)),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
