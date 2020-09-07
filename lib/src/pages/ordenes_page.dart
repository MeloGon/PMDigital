import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
  final ordenesProvider = new OrdenesProvider();
  TextStyle _oTextStyle =
      TextStyle(fontFamily: 'fuente72', fontSize: 14.0, color: Colors.black);
  TextStyle _titleOtStyle = TextStyle(
      fontSize: 14.0, color: Color(0xff32363A), fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    ordenesProvider.getOrdenes(widget.token);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
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
              'Mis órdenes hoy',
              style: _styleText,
            )
            // Your widgets here
          ],
        ),
        actions: [
          CircleAvatar(
            child: Icon(
              Icons.supervised_user_circle,
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: [numeroOrdenes(), spaceSearch(), headerBar(), ordenes()],
        ),
      ),
    );
  }

  void cantidad() async => await ordenesProvider.cantidadOrdenes(widget.token);

  Widget futureCantidad() {
    return FutureBuilder(
      future: ordenesProvider.cantidadOrdenes(widget.token),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            'Órdenes de trabajo (${snapshot.data.toString() ?? 0})',
            style: TextStyle(fontFamily: 'fuente72', fontSize: 20.0),
          );
        } else {
          return Text(
            'Órdenes de trabajo (Estimando ..)',
            style: TextStyle(fontFamily: 'fuente72', fontSize: 20.0),
          );
        }
      },
    );
  }

  Widget numeroOrdenes() {
    return Container(
      width: double.infinity,
      height: 48.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 0), // shadow direction: bottom right
          )
        ],
      ),
      child: futureCantidad(),
    );
  }

  Widget spaceSearch() {
    Widget inputBuscar = Container(
      color: Colors.white,
      width: 200.0,
      height: 30,
      child: TextField(
        style: TextStyle(fontFamily: 'fuente72', fontSize: 14.0),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(7),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0)),
          hintText: 'Buscar',
          hintStyle: TextStyle(fontStyle: FontStyle.italic),
          suffixIcon: Icon(
            Icons.search,
            color: Color(0xff0854a0),
          ),
        ),
      ),
    );
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 23.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          inputBuscar,
        ],
      ),
    );
  }

  Widget headerBar() {
    return Container(
      margin: EdgeInsets.only(top: 110.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: double.infinity,
      height: 45,
      color: Color(0xffF2F2F2),
      child: Row(
        children: [
          Expanded(
              child: Text(
            'Descripción',
            style: _styleText,
          )),
          Text(
            'Estatus',
            style: _styleText,
          ),
        ],
      ),
    );
  }

  Widget ordenes() {
    return Container(
      margin: EdgeInsets.only(top: 160.0),
      child: StreamBuilder(
        stream: ordenesProvider.ordenesStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<OrdenModel>> snapshot) {
          //ese signo de interrogacion dice has este foreach si existe data
          snapshot.data?.forEach((element) {
            //print(element.descripcion);
          });
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetallesOtPage(
              nrot: data.numeroOt.toString(),
              descriot: data.descripcion,
              token: widget.token,
              estado: data.estado,
            );
          }));
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
                TextSpan(text: '${data.numeroOt ?? ""}'),
              ]),
            ),
            SizedBox(
              height: 5.0,
            ),
            RichText(
              text: TextSpan(style: _oTextStyle, children: [
                TextSpan(
                    text: 'Tipo Orden: ', style: TextStyle(color: _greyColor)),
                TextSpan(text: '${data.tipoOt ?? ""}'),
              ]),
            ),
            SizedBox(
              height: 5.0,
            ),
            RichText(
              text: TextSpan(style: _oTextStyle, children: [
                TextSpan(
                    text: 'Prioridad: ', style: TextStyle(color: _greyColor)),
                TextSpan(text: '${data.prioridad ?? ""}'),
              ]),
            ),
          ],
        ),
        trailing: Container(
          width: 130.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${data.estado ?? ""}',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Hexcolor('${data.estadoColor}')),
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
