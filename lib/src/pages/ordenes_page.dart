import 'package:flutter/material.dart';
import 'package:pmdigital_app/src/models/OrdenModel.dart';
import 'package:pmdigital_app/src/pages/detalleot_page.dart';
import 'package:pmdigital_app/src/provider/ordenes_provider.dart';
import 'package:hexcolor/hexcolor.dart';

class OrdenesPage extends StatefulWidget {
  final String token;
  OrdenesPage({this.token});

  @override
  _OrdenesPageState createState() => _OrdenesPageState();
}

class _OrdenesPageState extends State<OrdenesPage> {
  Color _appBarColor = Color(0xff354A5F);
  Color _greyColor = Color(0xff6A6D70);
  TextStyle _appBarStyle = TextStyle(
    fontFamily: 'fuente72',
    fontSize: 14.0,
  );
  TextStyle _expandedBarStyle = TextStyle(
    fontFamily: 'fuente72',
    color: Colors.black,
    fontSize: 18.0,
  );
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
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          _appBarOrdenes(),

//           SliverList(delegate: SliverChildBuilderDelegate((context, index) {
//   return Container();
// })),
          SliverList(
              delegate: SliverChildListDelegate([
            _spaceSearch(),
            _headerBar(),
            // StreamBuilder(
            //   stream: ordenesProvider.ordenesStream,
            //   builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            //     //ese signo de interrogacion dice has este foreach si existe data
            //     snapshot.data?.forEach((element) {
            //       print(element.title);
            //     });
            //   },
            // ),

            Container(
              width: double.infinity,
              height: 600,
              child: StreamBuilder(
                stream: ordenesProvider.ordenesStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<OrdenModel>> snapshot) {
                  //ese signo de interrogacion dice has este foreach si existe data
                  snapshot.data?.forEach((element) {
                    //print(element.descripcion);
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
                        height: 400,
                        child: Center(child: CircularProgressIndicator()));
                  }
                },
              ),
            )
          ])),
        ],
      ),
    );
  }

  Widget _appBarOrdenes() {
    return SliverAppBar(
        elevation: 2.0,
        backgroundColor: _appBarColor,
        expandedHeight: 100,
        centerTitle: false,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20.0,
            child: Icon(
              Icons.supervised_user_circle,
              color: Colors.white,
            ),
          ),
        ],
        title: Text(
          'Estatus de órdenes',
          style: _appBarStyle,
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), onPressed: atrasButton),
        floating: true,
        pinned: true,
        //collapsedHeight: 100.0,
        flexibleSpace: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 70.0),
              width: double.infinity,
              color: Colors.white,
              height: 60,
            ),
            FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                padding: EdgeInsets.only(left: 20),
                width: double.infinity,
                child: Text(
                  'Mis órdenes para hoy',
                  style: _expandedBarStyle,
                ),
              ),
            ),
          ],
        ));
  }

  void atrasButton() {
    Navigator.pop(context);
  }

  Widget _spaceSearch() {
    Widget inputBuscar = Expanded(
      child: Container(
        color: Colors.white,
        height: 37,
        child: TextField(
          style: TextStyle(fontFamily: 'fuente72', fontSize: 14.0),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(2.0)),
            hintText: 'Buscar',
            suffixIcon: Icon(
              Icons.search,
              color: Color(0xff0854a0),
            ),
          ),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 23.0),
      child: Row(
        children: [
          Text(
            'Ordenes de Trabajo',
            overflow: TextOverflow.clip,
            style: _oTextStyle,
          ),
          SizedBox(
            width: 10.0,
          ),
          inputBuscar,
        ],
      ),
    );
  }

  Widget _headerBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: double.infinity,
      height: 45,
      color: Color(0xffF2F2F2),
      child: Row(
        children: [
          Expanded(child: Text('Descripción')),
          Text('Estatus'),
        ],
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
          width: 130.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${data.estado}',
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
